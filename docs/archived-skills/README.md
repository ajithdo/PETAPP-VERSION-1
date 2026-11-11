# Archived skills

Claude Code only loads skills from `.claude/skills/`. The skills in this folder are kept for reference and no longer load.

**Impeccable is now the only design skill.** Every other design-style skill is archived here so they don't compete with it. Impeccable reviews the Flutter screens from source code; its web detector doesn't apply to Flutter.

## What's here

| Folder | What it holds | Why it was retired |
| --- | --- | --- |
| `marketing/` | Corey Haines' 50 marketing skills | Not needed for building the app |
| `matt-pocock/` | Matt Pocock's 25 workflow skills | They overlap with Superpowers (for example `tdd` and `diagnosing-bugs`) |
| `design-alternatives/` | frontend-design, design, design-system, ui-styling, brand, brandkit, banner-design, slides, image-to-code, imagegen-frontend-mobile, imagegen-frontend-web, full-output-enforcement | They compete with Impeccable |
| `netlify/` | 13 Netlify skills | Only `netlify-deploy` and `netlify-config` are needed for the web demo |
| `other/` | webapp-testing, react-three-fiber, img2threejs | Flutter web draws on a canvas, so the Dart tools test it instead; no 3D in the app |
| top level | awesome-design-md, design-taste-frontend, design-taste-frontend-v1, gpt-taste, high-end-visual-design, industrial-brutalist-ui, minimalist-ui, redesign-existing-projects, stitch-design-taste, ui-ux-pro-max | Earlier design-style skills, archived before |

## How to restore a skill

Move its folder back into `.claude/skills/` with `git mv`, then commit. For example:

```sh
git mv docs/archived-skills/matt-pocock/grill-me .claude/skills/grill-me
git mv docs/archived-skills/minimalist-ui .claude/skills/minimalist-ui
```

Start a new Claude Code session afterwards so it picks the skill up. If you restore a design skill, also update the "Which tool for which job" list in `CLAUDE.md`, because it says Impeccable is the only design skill.
