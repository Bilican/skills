---
name: audio-to-report
description: Transcribe a local audio or video recording on-device with Whisper, then rewrite it as a themed, timestamp-free PDF report that loses no content. Use when the user points at a recording, lecture, talk, meeting, sermon, or voice note and wants it transcribed and/or written up as notes or a report.
---

# Audio to Report

Transcribe a recording **on-device**, then rewrite the transcript as a **themed, timestamp-free** PDF that keeps **no information back** — every claim, example, name, and term survives, regrouped by topic instead of by the order it was said.

Verify the transcript before you write from it; verify the report covers the transcript before you ship it.

## Phase 1 — Transcribe on-device (walkscribe)

`walkscribe` lives at `/Users/billyjohn/repositories-all/walkscribe`; the `large-v3` model is already cached and runs fully offline. Point it straight at the audio **or video** — it decodes either through ffmpeg, so no MP3 conversion is needed.

```bash
cd /Users/billyjohn/repositories-all/walkscribe && uv run walkscribe -l <lang> "<file>"
```

Force the dominant spoken language with `-l` (e.g. `-l tr`). This changes the output: auto-detect flips to the wrong script on quoted foreign passages (Arabic recitation, English asides) and corrupts whole 30-second segments. Set `-l` to whatever language the speaker mostly uses.

A long recording takes minutes (~10× real-time). Run it in the background and wait — the `.txt` lands next to the input file.

**Done when:** a `.txt` sits next to the input and its word count fits the duration (a 75-min talk is ≈ 10k words, not 200).

## Phase 2 — Extract exhaustively, in parallel

The transcript is **one single line**, so line paging fails on it. Slice it by character offset into ~18–20k-char chunks with ~1.5k overlap, then fan out **one subagent per chunk** at once. Each returns a dense outline of every teaching point, quote/narration (with its attribution), example, and defined term in its chunk. One context cannot hold a long transcript at full fidelity — chunked fan-out both prevents overload and stops detail from being silently dropped.

**Done when:** every chunk has a returned extraction and the chunk offsets tile the whole transcript (0 → end, no gap).

## Phase 3 — Write the report

- **Language:** the recording's language, unless the user asked for another.
- **Theme, not chronology.** Group the extractions into topic sections; merge a point raised in several places into one.
- **Keep** every claim and its reasoning chain, every quote / narration / citation, every example or anecdote that carries a point, and every defined term. **Drop** ASR repetition loops, dead air, and pure logistics or banter that teaches nothing — and name what you dropped in the closing note, so "dropped" can never hide "missed".
- **No timestamps.** No `[12:30]`, no "near the start he says".
- **Reconstruct** garbled proper nouns and foreign terms to their likely correct form. Mark each uncertain one with `(?)` inline and list it in a closing **uncertainty note** alongside its raw transcript form.
- Build from [`report-template.html`](report-template.html): a cover, an SVG **concept diagram** of the throughline, comparison **tables**, **callout** boxes for key claims / quotes / cited verses, **pills** for short lists, a **glossary** of the terms, and the uncertainty note. Reach for a diagram when structure beats prose (a process, a contrast, an anatomy), a table when comparing, a callout for a line worth stopping on.

**Done when:** every Phase-2 extraction maps to something in the report, and the report contains zero timestamps.

## Phase 4 — Render and verify

weasyprint and wkhtmltopdf are not installed here; render with Chrome:

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless=new --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="<out>.pdf" "file://<abs-path>/report.html"
```

`--no-pdf-header-footer` strips Chrome's injected date/URL margins.

Then look at it: render page 1 to PNG (`qlmanage -t -s 1100 -o <dir> "<out>.pdf"`) and read the image — confirm the cover, one table, and one diagram rendered, the language's accented characters are intact, and no header/footer leaked in. Save the PDF next to the recording and deliver it.

**Done when:** the PDF sits next to the recording, page 1 renders correctly on inspection, and you have delivered it.
