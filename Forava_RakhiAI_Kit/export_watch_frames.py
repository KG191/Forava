import cv2
import os
import argparse

def export_frames(video_path, out_dir, basename="ForavaRakhi", fps=12):
    os.makedirs(out_dir, exist_ok=True)
    cap = cv2.VideoCapture(video_path)
    frame_id = 0
    success, frame = cap.read()
    while success:
        out_path = os.path.join(out_dir, f"{basename}{frame_id:04d}.png")
        cv2.imwrite(out_path, frame)
        frame_id += 1
        for _ in range(int(cap.get(cv2.CAP_PROP_FPS)//fps)):
            success, frame = cap.read()
    cap.release()
    print(f"Exported {frame_id} frames to {out_dir}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--video", required=True)
    parser.add_argument("--out", required=True)
    parser.add_argument("--basename", default="ForavaRakhi")
    parser.add_argument("--fps", type=int, default=12)
    args = parser.parse_args()
    export_frames(args.video, args.out, args.basename, args.fps)
