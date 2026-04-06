#!/usr/bin/env python3
"""
Cipher Studio — Shop Icon Generator
Creates a 500x500 PNG with the Cipher Studio cipher circle mark.
Transparent background, all elements in Cipher Lime (#C8F53A).

Run: python3 scripts/make_icon.py
"""

import math
import os
from PIL import Image, ImageDraw

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
OUTPUT_SIZE = 500        # final PNG dimensions
SCALE       = 4          # supersample factor for anti-aliasing
DRAW_SIZE   = OUTPUT_SIZE * SCALE

CX = CY = DRAW_SIZE // 2

# Cipher Lime, fully opaque
LIME        = (200, 245, 58, 255)
TRANSPARENT = (0, 0, 0, 0)

# ---------------------------------------------------------------------------
# Drawing helpers
# ---------------------------------------------------------------------------
def s(v):
    """Scale a logical pixel value to the supersample canvas."""
    return int(v * SCALE)


def filled_circle(draw, cx, cy, r, color):
    draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=color)


def ring(draw, cx, cy, r, color, width):
    """Stroke-only circle."""
    draw.ellipse([cx - r, cy - r, cx + r, cy + r], outline=color, width=width)


def line(draw, p1, p2, color, width):
    draw.line([p1, p2], fill=color, width=width)


def dashed_circle(draw, cx, cy, r, color, width, dash_deg=22, gap_deg=11):
    """
    Draw a dashed circle by rendering short polyline segments along the arc.
    Uses computed points (not draw.arc) for consistent thick strokes.
    """
    angle = -90.0  # start at top
    end_angle = 270.0  # full revolution back to top

    while angle < end_angle:
        seg_end = min(angle + dash_deg, end_angle)
        steps = max(2, int(seg_end - angle))
        pts = []
        for i in range(steps + 1):
            a = math.radians(angle + (seg_end - angle) * i / steps)
            pts.append((cx + r * math.cos(a), cy + r * math.sin(a)))

        for i in range(len(pts) - 1):
            draw.line([pts[i], pts[i + 1]], fill=color, width=width)

        angle += dash_deg + gap_deg


# ---------------------------------------------------------------------------
# Icon geometry
# ---------------------------------------------------------------------------
def node_positions(cx, cy, radius, count=6, start_deg=-90):
    """Return (x, y) tuples for `count` evenly-spaced nodes on a circle."""
    positions = []
    for i in range(count):
        angle = math.radians(start_deg + i * (360 / count))
        positions.append((cx + radius * math.cos(angle),
                          cy + radius * math.sin(angle)))
    return positions


def build_icon():
    # ── Supersample canvas ─────────────────────────────────────────────────
    img  = Image.new("RGBA", (DRAW_SIZE, DRAW_SIZE), TRANSPARENT)
    draw = ImageDraw.Draw(img)

    # ── Radii (in logical pixels, scaled) ─────────────────────────────────
    R_OUTER_RING  = s(218)   # outer dashed ring
    R_NODES       = s(165)   # distance from center to outer node centres
    R_NODE_DOT    = s(15)    # radius of each outer node dot
    R_SPOKE_TRIM  = s(35)    # trim spokes so they start outside inner circle
    R_INNER_RING  = s(72)    # thin inner stroke ring
    R_CENTER_FILL = s(34)    # central filled circle
    R_CENTER_DOT  = s(10)    # tiny centre dot (accent on top)
    LINE_W        = s(3)     # spoke / hexagon line width
    RING_W        = s(4)     # outer dashed ring stroke width
    INNER_RING_W  = s(3)     # inner ring stroke width

    nodes = node_positions(CX, CY, R_NODES)

    # ── 1. Spokes: center → each outer node ────────────────────────────────
    # Trim the spoke start so it exits the inner fill circle cleanly
    for nx, ny in nodes:
        dx = nx - CX
        dy = ny - CY
        dist = math.hypot(dx, dy)
        ux, uy = dx / dist, dy / dist  # unit vector
        # start just outside inner fill circle
        x1 = CX + ux * (R_SPOKE_TRIM + LINE_W)
        y1 = CY + uy * (R_SPOKE_TRIM + LINE_W)
        # end just inside outer node dot edge
        x2 = nx - ux * (R_NODE_DOT - 1)
        y2 = ny - uy * (R_NODE_DOT - 1)
        line(draw, (x1, y1), (x2, y2), LIME, LINE_W)

    # ── 2. Hexagon edges: adjacent node → adjacent node ────────────────────
    for i in range(6):
        x1, y1 = nodes[i]
        x2, y2 = nodes[(i + 1) % 6]
        line(draw, (x1, y1), (x2, y2), LIME, LINE_W)

    # ── 3. Outer dashed ring ───────────────────────────────────────────────
    dashed_circle(draw, CX, CY, R_OUTER_RING, LIME, RING_W, dash_deg=22, gap_deg=11)

    # ── 4. Inner stroke ring ───────────────────────────────────────────────
    ring(draw, CX, CY, R_INNER_RING, LIME, INNER_RING_W)

    # ── 5. Outer node dots (filled circles) ───────────────────────────────
    for nx, ny in nodes:
        filled_circle(draw, nx, ny, R_NODE_DOT, LIME)

    # ── 6. Central filled circle (inner solid circle) ─────────────────────
    filled_circle(draw, CX, CY, R_CENTER_FILL, LIME)

    # ── 7. Centre dot (accent, drawn on top) ──────────────────────────────
    filled_circle(draw, CX, CY, R_CENTER_DOT, LIME)

    # ── Downscale to final size with LANCZOS for clean anti-aliasing ───────
    out = img.resize((OUTPUT_SIZE, OUTPUT_SIZE), Image.LANCZOS)
    return out


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    out_dir  = os.path.join(os.path.dirname(__file__), "..", "test-outputs")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "cipher-studio-icon.png")

    print("Rendering Cipher Studio icon...")
    icon = build_icon()
    icon.save(out_path, "PNG")

    size_kb = os.path.getsize(out_path) // 1024
    print(f"Saved: {out_path}")
    print(f"Size:  {OUTPUT_SIZE}x{OUTPUT_SIZE}px  ({size_kb} KB)")
    print(f"Mode:  {icon.mode}  (transparent background)")


if __name__ == "__main__":
    main()
