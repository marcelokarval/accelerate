#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CORPUS_DIR="$ROOT_DIR/references/design-md"
FETCHED_AT="2026-04-26"

entries=(
  "playstation|playstation|PlayStation|Gaming console retail|gaming / consumer electronics|Three-surface channel layout, quiet-authority display type, cyan hover-scale|gaming, console commerce, entertainment retail surfaces"
  "starbucks|starbucks|Starbucks|Global coffee retail brand|food retail / hospitality|Four-tier green system, warm cream canvas, full-pill buttons|hospitality, cafes, loyalty, food retail surfaces"
  "theverge|theverge|The Verge|Tech editorial media|media / editorial / consumer tech|Acid-mint and ultraviolet accents, Manuka display, rave-flyer story tiles|editorial media, news, high-energy story grids"
  "vodafone|vodafone|Vodafone|Global telecom brand|telecom / consumer services|Monumental uppercase display, Vodafone Red chapter bands|telecom, plans, consumer account surfaces"
  "wired|wired|WIRED|Tech magazine|media / editorial / technology|Paper-white broadsheet density, custom serif display, mono kickers, ink-blue links|magazine, dense editorial, long-form technology content"
  "airtable|airtable|Airtable|Spreadsheet-database hybrid|productivity / SaaS / database|Colorful, friendly, structured data aesthetic|tables, builders, workflow databases, friendly SaaS shells"
  "apple|apple|Apple|Consumer electronics|consumer electronics / premium retail|Premium white space, SF Pro, cinematic imagery|premium product marketing, hardware, minimal retail flows"
  "binance|binance|Binance|Crypto exchange|fintech / crypto / exchange|Bold yellow accent on monochrome, trading-floor urgency|crypto exchange, trading, high-frequency fintech dashboards"
  "bmw|bmw|BMW|Luxury automotive|automotive / luxury|Dark premium surfaces, precise German engineering aesthetic|premium automotive, configurators, performance product pages"
  "bugatti|bugatti|Bugatti|Hypercar brand|automotive / luxury / performance|Cinema-black canvas, monochrome austerity, monumental display type|ultra-premium automotive, luxury editorial product pages"
  "cal|cal|Cal.com|Open-source scheduling|productivity / scheduling / developer tools|Clean neutral UI, developer-oriented simplicity|scheduling, calendar, booking, developer productivity"
  "claude|claude|Claude|Anthropic AI assistant|AI / LLM platform|Warm terracotta accent, clean editorial layout|AI assistant, chat, research, calm product surfaces"
  "clay|clay|Clay|Creative agency|creative / agency / marketing|Organic shapes, soft gradients, art-directed layout|creative agency, portfolio, marketing experimentation"
  "clickhouse|clickhouse|ClickHouse|Fast analytics database|database / analytics / developer tools|Yellow-accented, technical documentation style|analytics DB, technical docs, data infrastructure consoles"
  "cohere|cohere|Cohere|Enterprise AI platform|AI / enterprise / dashboards|Vibrant gradients, data-rich dashboard aesthetic|enterprise AI, model platforms, data-heavy AI dashboards"
  "coinbase|coinbase|Coinbase|Crypto exchange|fintech / crypto / trust|Clean blue identity, trust-focused, institutional feel|crypto onboarding, institutional fintech, account dashboards"
  "composio|composio|Composio|Tool integration platform|developer tools / integrations / AI agents|Modern dark with colorful integration icons|integration marketplaces, agent tools, connector catalogs"
  "cursor|cursor|Cursor|AI-first code editor|developer tools / AI IDE|Sleek dark interface, gradient accents|AI coding tools, IDE landing pages, developer shells"
  "elevenlabs|elevenlabs|ElevenLabs|AI voice platform|AI / audio / media generation|Dark cinematic UI, audio-waveform aesthetics|voice AI, audio creation, media tools"
  "expo|expo|Expo|React Native platform|developer tools / mobile platform|Dark theme, tight letter-spacing, code-centric|mobile developer platforms, app deployment, docs"
  "ferrari|ferrari|Ferrari|Luxury automotive|automotive / luxury / performance|Chiaroscuro editorial, Ferrari Red accents, cinematic black|performance automotive, luxury brand editorial"
  "figma|figma|Figma|Collaborative design tool|design tools / collaboration|Vibrant multi-color, playful yet professional|design collaboration, canvas tools, creative SaaS"
  "framer|framer|Framer|Website builder|design tools / website builder|Bold black and blue, motion-first, design-forward|website builders, creative tooling, motion-led marketing"
  "hashicorp|hashicorp|HashiCorp|Infrastructure automation|devops / infrastructure / enterprise|Enterprise-clean, black and white|infrastructure platforms, enterprise docs, DevOps consoles"
  "ibm|ibm|IBM|Enterprise technology|enterprise / technology / design system|Carbon design system, structured blue palette|enterprise apps, structured admin, data and AI platforms"
  "intercom|intercom|Intercom|Customer messaging|customer support / SaaS|Friendly blue palette, conversational UI patterns|support, messaging, customer success dashboards"
  "kraken|kraken|Kraken|Crypto trading|fintech / crypto / trading|Purple-accented dark UI, data-dense dashboards|trading terminals, crypto dashboards, market data surfaces"
  "lamborghini|lamborghini|Lamborghini|Supercar brand|automotive / luxury / performance|True black surfaces, gold accents, dramatic uppercase typography|luxury automotive, performance editorial, high-drama product pages"
  "lovable|lovable|Lovable|AI full-stack builder|AI / developer tools / app builder|Playful gradients, friendly dev aesthetic|AI builders, friendly developer onboarding, app generation"
  "mastercard|mastercard|Mastercard|Global payments network|fintech / payments / consumer trust|Warm cream canvas, orbital pill shapes, editorial warmth|payments, financial trust, consumer finance, partner portals"
  "meta|meta|Meta|Tech retail store|consumer tech / social / retail|Photography-first, binary light/dark surfaces, Meta Blue CTAs|consumer tech retail, device pages, social platform surfaces"
  "minimax|minimax|MiniMax|AI model provider|AI / model platform|Bold dark interface with neon accents|model providers, AI infra, dark technical marketing"
  "mintlify|mintlify|Mintlify|Documentation platform|developer tools / docs|Clean, green-accented, reading-optimized|documentation sites, developer portals, API references"
  "miro|miro|Miro|Visual collaboration|productivity / collaboration / canvas|Bright yellow accent, infinite canvas aesthetic|whiteboards, collaboration, infinite canvas tools"
  "mistral.ai|mistral-ai|Mistral AI|Open-weight LLM provider|AI / model platform / open weights|French-engineered minimalism, purple-toned|AI model platforms, technical marketing, research product pages"
  "mongodb|mongodb|MongoDB|Document database|database / developer tools|Green leaf branding, developer documentation focus|database docs, cloud DB consoles, developer onboarding"
  "nike|nike|Nike|Athletic retail|e-commerce / retail / sports|Monochrome UI, massive uppercase type, full-bleed photography|sports retail, product drops, image-led commerce"
  "nvidia|nvidia|NVIDIA|GPU computing|AI infrastructure / hardware|Green-black energy, technical power aesthetic|GPU platforms, AI infrastructure, technical hardware surfaces"
  "ollama|ollama|Ollama|Run LLMs locally|AI / local models / developer tools|Terminal-first, monochrome simplicity|local AI tools, CLI-first developer products"
  "opencode.ai|opencode-ai|OpenCode|AI coding platform|AI / developer tools|Developer-centric dark theme|AI coding agents, developer control planes, IDE-adjacent apps"
  "pinterest|pinterest|Pinterest|Visual discovery|consumer / media / visual search|Red accent, masonry grid, image-first|visual discovery, moodboards, inspiration galleries"
  "posthog|posthog|PostHog|Product analytics|analytics / developer tools|Playful hedgehog branding, developer-friendly dark UI|product analytics, event dashboards, developer SaaS"
  "raycast|raycast|Raycast|Productivity launcher|productivity / launcher / developer tools|Sleek dark chrome, vibrant gradient accents|command palettes, launchers, productivity tooling"
  "renault|renault|Renault|French automotive|automotive / consumer brand|Vibrant aurora gradients, NouvelR typography, bold energy|automotive marketing, electric mobility, campaign pages"
  "replicate|replicate|Replicate|Run ML models via API|AI / ML platform / developer tools|Clean white canvas, code-forward|model APIs, ML tooling, developer docs"
  "resend|resend|Resend|Email API|developer tools / email infrastructure|Minimal dark theme, monospace accents|email APIs, developer infrastructure, transactional messaging"
  "revolut|revolut|Revolut|Digital banking|fintech / banking / consumer finance|Sleek dark interface, gradient cards, fintech precision|banking apps, cards, consumer finance dashboards"
  "runwayml|runwayml|Runway|AI video generation|AI / media generation / video|Cinematic dark UI, media-rich layout|video AI, creative media tools, content generation"
  "sanity|sanity|Sanity|Headless CMS|CMS / content platform|Red accent, content-first editorial layout|content platforms, editorial tools, structured CMS UIs"
  "sentry|sentry|Sentry|Error monitoring|developer tools / observability|Dark dashboard, data-dense, pink-purple accent|observability, error tracking, incident dashboards"
  "shopify|shopify|Shopify|E-commerce platform|e-commerce / retail infrastructure|Dark-first cinematic, neon green accent, ultra-light type|commerce platforms, merchant dashboards, retail marketing"
  "spacex|spacex|SpaceX|Space technology|aerospace / technology|Stark black and white, full-bleed imagery, futuristic|aerospace, frontier tech, high-contrast launch pages"
  "spotify|spotify|Spotify|Music streaming|media / consumer tech / music|Vibrant green on dark, bold type, album-art-driven|music, media discovery, audio products"
  "supabase|supabase|Supabase|Open-source Firebase alternative|backend / database / developer tools|Dark emerald theme, code-first|backend platforms, database dashboards, developer docs"
  "superhuman|superhuman|Superhuman|Fast email client|productivity / email / premium SaaS|Premium dark UI, keyboard-first, purple glow|email clients, power-user productivity, keyboard-first apps"
  "tesla|tesla|Tesla|Electric automotive|automotive / consumer tech|Radical subtraction, full-viewport photography, near-zero UI|EV marketing, configurators, minimal premium product pages"
  "together.ai|together-ai|Together AI|Open-source AI infrastructure|AI infrastructure / model platform|Technical, blueprint-style design|AI infra, model APIs, research platforms"
  "uber|uber|Uber|Mobility platform|mobility / marketplace / consumer services|Bold black and white, tight type, urban energy|mobility, delivery, marketplace operations"
  "voltagent|voltagent|VoltAgent|AI agent framework|AI agents / developer tools|Void-black canvas, emerald accent, terminal-native|agent frameworks, terminal-native developer products"
  "warp|warp|Warp|Modern terminal|developer tools / terminal|Dark IDE-like interface, block-based command UI|terminals, command surfaces, developer productivity"
  "webflow|webflow|Webflow|Visual web builder|design tools / website builder|Blue-accented, polished marketing site aesthetic|visual builders, no-code tools, marketing sites"
  "wise|wise|Wise|Money transfer|fintech / money transfer|Bright green accent, friendly and clear|money transfer, consumer fintech, international payments"
  "x.ai|x-ai|xAI|AI lab|AI / research / model platform|Stark monochrome, futuristic minimalism|AI research labs, frontier model marketing"
  "zapier|zapier|Zapier|Automation platform|automation / integrations / productivity|Warm orange, friendly illustration-driven|automation builders, integrations, workflow tooling"
)

mkdir -p "$CORPUS_DIR"

for entry in "${entries[@]}"; do
  IFS='|' read -r source_slug local_slug title summary category influence recommended <<< "$entry"
  entry_dir="$CORPUS_DIR/$local_slug"
  source_url="https://getdesign.md/design-md/$source_slug/DESIGN.md"
  mkdir -p "$entry_dir"
  curl -fsSL "$source_url" -o "$entry_dir/DESIGN.md"
  {
    printf '# %s DESIGN.md Metadata\n\n' "$title"
    printf 'source-url: `%s`\n' "$source_url"
    printf 'fetched-at: `%s`\n' "$FETCHED_AT"
    printf 'not-official: `true`\n'
    printf 'source-provider: `getdesign.md`\n'
    printf 'local-slug: `%s`\n' "$local_slug"
    printf 'source-slug: `%s`\n' "$source_slug"
    printf 'category: `%s`\n' "$category"
    printf 'primary-influence: `%s`\n' "$influence"
    printf 'recommended-use: `%s`\n\n' "$recommended"
    printf '## Provenance\n\n'
    printf 'This entry was imported into the Accelerate repo-local DESIGN.md corpus from getdesign.md. It is a curated reference artifact, not an official brand design system.\n\n'
    printf '## Trust Limits\n\n'
    printf -- '- Use for premium influence, contrast, density, rhythm, motion, typography, and token mapping.\n'
    printf -- '- Do not use for brand cloning, trademark-confusing UI, or direct implementation authority.\n'
    printf -- '- Map all adopted influence into local `design-system.contract.md`, `design-system.theme.css`, and `--ds-*` tokens before implementation.\n'
  } > "$entry_dir/metadata.md"
done

echo "Imported ${#entries[@]} DESIGN.md entries into $CORPUS_DIR"
