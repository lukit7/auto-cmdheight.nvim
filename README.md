# 🚀 Auto Cmd Height for Neovim

Welcome to the **Auto Cmd Height** plugin for Neovim! This plugin automatically adjusts the command height in your Neovim editor, enhancing your coding experience. Whether you are a beginner or an experienced developer, this tool aims to streamline your workflow.

[![Download Releases](https://img.shields.io/badge/Download%20Releases-Click%20Here-blue)](https://github.com/lukit7/auto-cmdheight.nvim/releases)

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Features

- **Automatic Adjustment**: The plugin automatically adjusts the command height based on the content. No more awkward empty spaces!
- **Simple Setup**: Easy to install and configure, allowing you to focus on coding.
- **Lightweight**: Minimal resource usage ensures that your Neovim remains fast and responsive.
- **Customizable**: Adjust settings to fit your personal preferences.

## Installation

To install **Auto Cmd Height**, follow these simple steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/lukit7/auto-cmdheight.nvim.git
   ```

2. **Navigate to the Directory**:
   ```bash
   cd auto-cmdheight.nvim
   ```

3. **Download and Execute**: Visit the [Releases section](https://github.com/lukit7/auto-cmdheight.nvim/releases) to download the latest release. Follow the instructions provided there to execute the plugin.

## Usage

After installation, you can start using the plugin right away. The command height will adjust automatically based on your input. No additional commands are necessary. Just open Neovim and start typing!

## Configuration

You can customize the behavior of the Auto Cmd Height plugin. Here are some options you might consider:

```lua
-- Example configuration
require('cmdheight').setup {
    height = 2,  -- Set the default height
    auto_resize = true,  -- Enable auto-resizing
}
```

Adjust these settings according to your needs. You can find more options in the [documentation](https://github.com/lukit7/auto-cmdheight.nvim/releases).

## Contributing

Contributions are welcome! If you have ideas for new features or improvements, feel free to open an issue or submit a pull request. Please ensure your code adheres to the existing style and includes tests where applicable.

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Special thanks to the Neovim community for their ongoing support and contributions.
- Thanks to all contributors who have helped make this plugin better.

## Support

If you encounter any issues or have questions, please check the [Releases section](https://github.com/lukit7/auto-cmdheight.nvim/releases) for troubleshooting tips. You can also open an issue on GitHub for assistance.

---

Thank you for using **Auto Cmd Height**! We hope it enhances your Neovim experience.