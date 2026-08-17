import os
import shutil
from skimage import io, color, transform
from skimage.metrics import structural_similarity as ssim
import numpy as np
from robot.api import logger


class VisualValidator:
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def verify_slide_design(self, baseline_path, actual_path, threshold=0.98, region=None):
        """Compares an actual screenshot against a baseline image using SSIM.
        If baseline is missing, the actual image is saved as the new baseline and the keyword passes with a warning.
        Optionally pass a region as `x,y,width,height` (string or iterable) to compare only that rectangle.
        """
    
        if not os.path.exists(actual_path):
            raise AssertionError(f"Actual screenshot not found: {actual_path}")

        
        if not os.path.exists(baseline_path):
            os.makedirs(os.path.dirname(baseline_path), exist_ok=True)
            shutil.copy2(actual_path, baseline_path)
            logger.warn(f"Baseline missing. Copied actual to baseline: {baseline_path}")
            return True

        # Load images using scikit-image
        img_baseline = io.imread(baseline_path)
        img_actual = io.imread(actual_path)

        # Normalize channel layout so both RGBA and grayscale inputs can be compared safely.
        def _normalize_channels(img):
            if img is None:
                return img
            if img.ndim == 2:
                # Convert grayscale images to an RGB-like 3-channel array so all later code paths match.
                return np.repeat(img[:, :, np.newaxis], 3, axis=2)
            if img.shape[2] == 1:
                return np.repeat(img, 3, axis=2)
            if img.shape[2] == 4:
                try:
                    img = color.rgba2rgb(img)
                except Exception:
                    img = img[:, :, :3]
            elif img.shape[2] > 3:
                img = img[:, :, :3]
            return img

        img_baseline = _normalize_channels(img_baseline)
        img_actual = _normalize_channels(img_actual)

        # If region is provided, parse and crop images to region (x,y,w,h)
        if region:
            # Accept region as string 'x,y,w,h' or iterable
            if isinstance(region, str):
                parts = [p.strip() for p in region.split(',') if p.strip()]
                try:
                    region_vals = [int(float(p)) for p in parts]
                except Exception:
                    raise AssertionError(f"Invalid region string: {region}")
            else:
                region_vals = list(region)

            if len(region_vals) != 4:
                raise AssertionError(f"Region must be 4 values: x,y,width,height. Got: {region}")

            x, y, w, h = region_vals
            # image arrays are (H, W, C)
            h_img, w_img = img_actual.shape[0], img_actual.shape[1]
            x1 = max(0, x)
            y1 = max(0, y)
            x2 = min(w_img, x + w)
            y2 = min(h_img, y + h)
            if x1 >= x2 or y1 >= y2:
                raise AssertionError(f"Region out of bounds or zero-sized: {region_vals}")

            img_actual = img_actual[y1:y2, x1:x2]
            img_baseline = img_baseline[y1:y2, x1:x2]

        # Ensure images are the exact same dimensions before comparison
        if img_baseline.shape != img_actual.shape:
            img_actual = transform.resize(img_actual, img_baseline.shape, preserve_range=True).astype(np.uint8)

        # Convert to grayscale for structural comparison.
        gray_baseline = color.rgb2gray(img_baseline)
        gray_actual = color.rgb2gray(img_actual)

        # Compute Structural Similarity (1.0 means perfectly identical)
        data_range = float(np.max(gray_actual) - np.min(gray_actual))
        if data_range == 0:
            data_range = 1.0
        score, _ = ssim(gray_baseline, gray_actual, data_range=data_range, full=True)

        logger.info(f"Visual similarity score: {score:.4f} (threshold: {threshold})")

        if score < float(threshold):
            # Attempt to save a visual diff to help debugging
            try:
                # compute absolute difference image from grayscale arrays
                diff = np.abs(gray_baseline - gray_actual)
                # normalize to 0-255 uint8
                diff_norm = (255 * (diff - diff.min()) / (diff.ptp() if diff.ptp() != 0 else 1)).astype(np.uint8)

                # construct diff path next to actual image
                actual_dir = os.path.dirname(actual_path) or '.'
                base_name = os.path.splitext(os.path.basename(actual_path))[0]
                diff_path = os.path.join(actual_dir, f"{base_name}_diff.png")

                # Save diff as grayscale PNG
                io.imsave(diff_path, diff_norm)
                logger.error(f"Design mismatch for baseline='{baseline_path}' actual='{actual_path}'. Similarity={score:.4f}. Diff saved to: {diff_path}")
            except Exception as e:
                logger.warn(f"Failed to save visual diff: {e}")

            raise AssertionError(f"Design mismatch for baseline='{baseline_path}' actual='{actual_path}'. Similarity={score:.4f} (Threshold: {threshold})")

        return True
