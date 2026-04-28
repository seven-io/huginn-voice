<p align="center">
  <img src="https://www.seven.io/wp-content/uploads/Logo.svg" width="250" alt="seven logo" />
</p>

<h1 align="center">seven Voice for Huginn</h1>

<p align="center">
  Huginn agent gem that places text-to-speech voice calls via the seven gateway.
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-teal.svg" alt="MIT License" /></a>
  <img src="https://img.shields.io/badge/Huginn-agent%20gem-blue" alt="Huginn agent gem" />
  <img src="https://img.shields.io/badge/Ruby-2.7%2B-red" alt="Ruby 2.7+" />
  <a href="https://rubygems.org/gems/huginn_seven_voice_agent"><img src="https://img.shields.io/gem/v/huginn_seven_voice_agent" alt="Gem" /></a>
</p>

---

## Features

- **Voice / Text-to-Speech** - Drop-in agent for any Huginn scenario that needs voice output
- **Standard Gem** - Loads via the Huginn `ADDITIONAL_GEMS` mechanism, no source patching

## Prerequisites

- A self-hosted [Huginn](https://github.com/huginn/huginn) instance
- A [seven account](https://www.seven.io/) with API key ([How to get your API key](https://help.seven.io/en/developer/where-do-i-find-my-api-key))

## Installation

Append `huginn_seven_voice_agent` to your Huginn `.env` `ADDITIONAL_GEMS` value:

```dotenv
ADDITIONAL_GEMS=huginn_seven_voice_agent
```

Then re-run `bundle` and restart Huginn:

```bash
bundle
```

## Configuration

In Huginn, create a new agent of type **Seven Voice Agent**, paste your seven API key into the agent options and configure the spoken message template.

## Usage

Wire the seven voice agent as the receiver of any Huginn event source. Each event triggers a phone call that reads out the rendered template.

## Support

Need help? Feel free to [contact us](https://www.seven.io/en/company/contact/) or [open an issue](https://github.com/seven-io/huginn-voice/issues).

## License

[MIT](LICENSE)
