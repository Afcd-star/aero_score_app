// lib/src/features/auth/presentation/views/auth_view.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/app_dimens.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/core/theme/theme_provider.dart';
import 'package:aero_score_app/src/features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/features/auth/presentation/providers/auth_notifier.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_button.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_card.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_form.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fondo de marca del acceso, oscuro en ambos modos por decision de identidad.
const String _kLoginBackgroundAsset = 'assets/images/login_glow.png';

/// Vista de autenticación para iniciar sesión o registrarse.
class AuthView extends ConsumerStatefulWidget {
  /// Crea la vista de autenticación.
  const AuthView({super.key});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _obscurePass = true;
  bool _errorShown = false;

  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  static final RegExp _emailPattern = RegExp(
    r'^[\u002D\w.]+'
    r'@([\u002D\w]+\.)+'
    r'[\u002D\w]{2,4}$',
  );

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted || _errorShown) {
      return;
    }
    _errorShown = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    unawaited(
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          _errorShown = false;
        }
      }),
    );
  }

  ({String firstName, String lastName}) _splitFullName(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return (firstName: '', lastName: '');
    }
    if (parts.length == 1) {
      return (firstName: parts.first, lastName: '');
    }
    final lastName = parts.removeLast();
    final firstName = parts.join(' ');
    return (firstName: firstName, lastName: lastName);
  }

  Future<void> _handleSubmit() async {
    if (!mounted) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final notifier = ref.read(authProvider.notifier);
    if (_isLogin) {
      await notifier.login(
        _usernameCtrl.text.trim(),
        _passwordCtrl.text.trim(),
      );
      return;
    }
    final names = _splitFullName(_fullNameCtrl.text.trim());
    await notifier.register(
      username: _usernameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      passwordConfirm: _confirmPassCtrl.text.trim(),
      firstName: names.firstName,
      lastName: names.lastName,
    );
  }

  void _toggleMode() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLogin = !_isLogin;
      _errorShown = false;
      _formKey.currentState?.reset();
      _fullNameCtrl.clear();
      _emailCtrl.clear();
      _usernameCtrl.clear();
      _passwordCtrl.clear();
      _confirmPassCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<AuthState>(
      authProvider,
      (previous, next) {
        if (next is AuthInitial && next.registrationSuccess) {
          if (!mounted || _errorShown) {
            return;
          }
          _errorShown = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Registro exitoso. Tu cuenta '
                      'está pendiente de aprobación.',
                    ),
                  ),
                ],
              ),
              backgroundColor: isDark
                  ? AppColors.successDark
                  : AppColors.successLight,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          unawaited(
            Future.delayed(
              const Duration(seconds: 4),
              () {
                if (mounted) {
                  ref.read(authProvider.notifier).clearRegistrationSuccess();
                  _errorShown = false;
                }
              },
            ),
          );
          return;
        }
        if (next is AuthError) {
          _showError(next.failure.message);
        }
      },
    );

    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_kLoginBackgroundAsset),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLogo(),
                        const SizedBox(height: 32),
                        _buildAuthCard(
                          isLoading,
                          isDark,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 0,
                right: 12,
                child: SafeArea(
                  bottom: false,
                  left: false,
                  child: Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: _ThemeModeSelector(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo_sin_fondo.png',
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
        Text(
          'AeroScore',
          style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthCard(bool isLoading, bool isDark) {
    return AeroCard(
      padding: const EdgeInsets.all(24),
      child: AeroForm(
        formKey: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToggleSwitch(isDark),
            const SizedBox(height: 24),
            if (_isLogin)
              _buildLoginForm(isLoading)
            else
              _buildRegisterForm(isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch(bool isDark) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          _buildTabOption(
            'Iniciar sesión',
            true,
            isDark,
          ),
          _buildTabOption(
            'Registrarse',
            false,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildTabOption(
    String label,
    bool isLoginTab,
    bool isDark,
  ) {
    final isActive = _isLogin == isLoginTab;
    final activeShadow = <BoxShadow>[
      BoxShadow(
        color: AppColors.fuchsia.withValues(alpha: 0.5),
        blurRadius: 15,
      ),
    ];
    return Expanded(
      child: GestureDetector(
        onTap: _toggleMode,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.fuchsia : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: isActive ? activeShadow : const <BoxShadow>[],
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                fontSize: 14,
                color: isActive
                    ? Colors.white
                    : (isDark
                          ? AppColors.mutedForegroundDark
                          : AppColors.foregroundLight),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(bool isLoading) {
    return Column(
      children: [
        AeroFormField(
          label: 'Usuario',
          required: true,
          field: AeroInput(
            controller: _usernameCtrl,
            hintText: 'Inserte su usuario',
            validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
          ),
        ),
        const SizedBox(height: 16),
        AeroFormField(
          label: 'Contraseña',
          required: true,
          field: AeroInput(
            controller: _passwordCtrl,
            hintText: 'Inserte su contraseña',
            obscureText: _obscurePass,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePass ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(
                  () => _obscurePass = !_obscurePass,
                );
              },
            ),
            validator: (v) => v?.isEmpty == true ? 'Campo requerido' : null,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: AeroButton(
            label: 'Iniciar sesión',
            onPressed: isLoading ? null : () => unawaited(_handleSubmit()),
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(bool isLoading) {
    return Column(
      children: [
        AeroFormField(
          label: 'Nombre completo',
          required: true,
          field: AeroInput(
            controller: _fullNameCtrl,
            hintText: 'Escriba su nombre completo',
            validator: (v) => v?.isEmpty == true ? 'Campo requerido' : null,
          ),
        ),
        const SizedBox(height: 16),
        AeroFormField(
          label: 'Email',
          required: true,
          field: AeroInput(
            controller: _emailCtrl,
            hintText: 'Inserte su email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v?.isEmpty == true) {
                return 'Campo requerido';
              }
              if (!_emailPattern.hasMatch(v!)) {
                return 'Email inválido';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
        AeroFormField(
          label: 'Usuario',
          required: true,
          field: AeroInput(
            controller: _usernameCtrl,
            hintText: 'Inserte su usuario',
            validator: (v) => v?.isEmpty == true ? 'Campo requerido' : null,
          ),
        ),
        const SizedBox(height: 16),
        AeroFormField(
          label: 'Contraseña',
          required: true,
          field: AeroInput(
            controller: _passwordCtrl,
            hintText: 'Inserte su contraseña',
            obscureText: _obscurePass,
            validator: (v) {
              if (v?.isEmpty == true) {
                return 'Campo requerido';
              }
              if (v!.length < 8) {
                return 'Mínimo 8 caracteres';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
        AeroFormField(
          label: 'Confirmar contraseña',
          required: true,
          field: AeroInput(
            controller: _confirmPassCtrl,
            hintText: 'Repita su contraseña',
            obscureText: _obscurePass,
            validator: (v) {
              if (v?.isEmpty == true) {
                return 'Campo requerido';
              }
              if (v != _passwordCtrl.text) {
                return 'Las contraseñas '
                    'no coinciden';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: AeroButton(
            label: 'Registrarse',
            onPressed: isLoading ? null : () => unawaited(_handleSubmit()),
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}

/// Selector compacto de modo de tema para la
/// esquina superior derecha.
class _ThemeModeSelector extends ConsumerWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (icon, label) = switch (themeMode) {
      ThemeMode.light => (
        Icons.light_mode_rounded,
        'Claro',
      ),
      ThemeMode.dark => (
        Icons.dark_mode_rounded,
        'Oscuro',
      ),
      _ => (
        Icons.brightness_auto_rounded,
        'Sistema',
      ),
    };

    return PopupMenuButton<ThemeMode>(
      tooltip: 'Cambiar tema: $label',
      initialValue: themeMode,
      onSelected: (mode) {
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem<ThemeMode>(
          value: ThemeMode.system,
          child: _ThemeOption(
            icon: Icons.brightness_auto_rounded,
            label: 'Sistema',
          ),
        ),
        const PopupMenuItem<ThemeMode>(
          value: ThemeMode.light,
          child: _ThemeOption(
            icon: Icons.light_mode_rounded,
            label: 'Claro',
          ),
        ),
        const PopupMenuItem<ThemeMode>(
          value: ThemeMode.dark,
          child: _ThemeOption(
            icon: Icons.dark_mode_rounded,
            label: 'Oscuro',
          ),
        ),
      ],
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppDimens.controlHeight,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? scheme.surfaceContainerHighest.withValues(alpha: 0.85)
              : Colors.white.withValues(
                  alpha: 0.9,
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: scheme.onSurface,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Opción individual dentro del menú emergente.
class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: scheme.primary),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }
}
