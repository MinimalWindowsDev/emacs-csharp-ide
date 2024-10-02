# emacs-csharp-ide

A local, project-specific Emacs configuration for C# development with zero global setup.

## Features

- Local package management (no global Emacs configuration required)
- C# syntax highlighting, autocompletion, and error checking
- XAML support
- Git integration with Magit
- One-key build (F5) and run (F6) functionality
- Project management with Projectile

## Setup

1. Clone this repository or copy the `.dir-locals.el` file to your C# project root.
2. Open your project in Emacs.
3. On first run, Emacs will install necessary packages locally (this may take a few minutes).

## Usage

- `F5`: Build the current C# file
- `F6`: Run the last built executable
- `C-c p`: Projectile prefix command
- `C-x g`: Open Magit status

## Requirements

- Emacs 26.1 or later
- Visual Studio 2019 (for C# compiler)

## License

This project is licensed under the WTFPL - see the [LICENSE](LICENSE) file for details.