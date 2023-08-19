import 'package:flutter_riverpod/flutter_riverpod.dart';

final indexprovider = StateProvider<int>((ref) => 0);
final loopprovider = StateProvider<bool>((ref) => true);
final playprovider = StateProvider<bool>((ref) => true);
final sheetprovider = StateProvider<bool>((ref) => false);
