# Forava Rakhi AI Creation Plan

## Vision
Users design their own digital Rakhi with AI assistance. They choose a genre (Traditional, Modern, Elegant, Spiritual), then select up to 25 descriptive elements. Each element maps to tokens & control settings for AI image generation.

## Key Components
- **Prompt Builder**: maps user selections to AI-ready prompt tokens.
- **AI Agents**: 4 genre-specialized models/pipelines.
- **Image Generator**: ComfyUI + SDXL + ControlNet/IPAdapter.
- **Animation**: subtle glow or rotation exported as frames/MP4.
- **Export**: iPhone & WatchKit (frame packs).

## Workflow
1. **UI**: User picks genre & elements → DesignSpec JSON.
2. **Prompt Assembly**: JSON mapped via CSV table → tokens & weights.
3. **Generation**: ComfyUI workflow consumes prompt & produces PNG.
4. **Animation**: Add rotation/glow with AnimateDiff or frame shader.
5. **Export**: Python tool splits MP4 → WatchKit frame pack.

## Deployment
- GPU box (A100, 40GB VRAM) or Replicate/Fal for generation.
- SwiftUI frontend integrates builder + preview.
