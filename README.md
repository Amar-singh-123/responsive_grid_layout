# responsive_grid_layout

[![pub package](https://img.shields.io/pub/v/responsive_grid_layout.svg)](https://pub.dev/packages/responsive_grid_layout)
[![popularity](https://img.shields.io/pub/popularity/responsive_grid_layout.svg)](https://pub.dev/packages/responsive_grid_layout/score)
[![likes](https://img.shields.io/pub/likes/responsive_grid_layout.svg)](https://pub.dev/packages/responsive_grid_layout/score)
[![pub points](https://img.shields.io/pub/points/responsive_grid_layout.svg)](https://pub.dev/packages/responsive_grid_layout/score)

A powerful, customizable responsive grid widget for Flutter with automatic width calculation and flexible layout options.

## ✨ Features

- 🎯 **Automatic width calculation** - Perfect item sizing based on available space
- 📱 **Responsive by default** - Adapts to different screen sizes automatically
- 🎨 **Flexible layouts** - Fixed or responsive modes
- ⚡ **High performance** - Efficient rendering with builder pattern
- 🎭 **Animation support** - Smooth transitions when items appear
- 🔄 **Loading states** - Built-in skeleton loading
- 📦 **Easy to use** - Intuitive API with sensible defaults

## 📸 Screenshots

![Responsive Grid Layout Screenshot](https://raw.githubusercontent.com/Amar-singh-123/responsive_grid_layout/master/screenshots/screenshot1.png)

## 🚀 Getting Started

Add this to your `pubspec.yaml`:
```yaml
dependencies:
  responsive_grid_layout: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## 💡 Usage

### Basic Example
```dart
import 'package:responsive_grid_layout/responsive_grid_layout.dart';

ResponsiveGrid(
  itemCount: items.length,
  itemsPerRow: 3,
  horizontalSpacing: 16,
  verticalSpacing: 16,
  itemBuilder: (context, index, width) {
    return MyCard(data: items[index]);
  },
)
```

### Responsive Mode
```dart
ResponsiveGrid(
  itemCount: products.length,
  minItemWidth: 250,  // Minimum width per item
  maxItemsPerRow: 4,  // Max items on large screens
  itemBuilder: (context, index, width) {
    return ProductCard(product: products[index]);
  },
)
```

### Using Children
```dart
ResponsiveGrid(
  itemsPerRow: 3,
  children: [
    Card(child: Text('Item 1')),
    Card(child: Text('Item 2')),
    Card(child: Text('Item 3')),
  ],
)
```

## 📖 Full Documentation

For complete documentation, examples, and API reference, visit:
- [pub.dev documentation](https://pub.dev/packages/responsive_grid_layout)
- [Example app](https://github.com/Amar-singh-123/responsive_grid_layout/tree/master/example)

## 🤝 Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) first.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💖 Support

If you find this package useful, please consider:
- ⭐ Starring the repo
- 👍 Liking on pub.dev
- 🐛 Reporting issues
- 💡 Suggesting new features

## 📧 Contact

- GitHub: [@Amar-singh-123](https://github.com/Amar-singh-123)
- Email: amarnathsingh9495@gmail.com