import 'package:flutter/material.dart';

/// Embeddable NavigationRail widget.
///
/// Use this widget inside a layout (for example, dentro da coluna 1) para
/// mostrar a barra de navegação sem possuir seu próprio `main()` ou `Scaffold`.
class AppNavigationRail extends StatefulWidget {
  /// Callback chamado quando o usuário seleciona um destino.
  final ValueChanged<int>? onDestinationSelected;
  /// Lista customizada de destinos. Se for nula, serão usados os destinos
  /// padrão (Chats, Contatos, Ajustes).
  final List<NavigationRailDestination>? destinations;
  /// Índice selecionado controlado externamente. Se fornecido, o widget não
  /// gerenciará seu próprio estado e usará este valor.
  final int? selectedIndex;
  /// Widget opcional exibido acima do NavigationRail (por exemplo um botão
  /// manual que você queira adicionar). Se null, não é exibido.
  final Widget? leading;
  /// Widget opcional exibido abaixo do NavigationRail (por exemplo um botão
  /// de configurações). Se null, não é exibido.
  final Widget? trailing;

  const AppNavigationRail({
    super.key,
    this.onDestinationSelected,
    this.destinations,
    this.leading,
    this.trailing,
    this.selectedIndex,
  });

  @override
  State<AppNavigationRail> createState() => _AppNavigationRailState();
}

class _AppNavigationRailState extends State<AppNavigationRail> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final dests = widget.destinations ?? const <NavigationRailDestination>[
      NavigationRailDestination(
        icon: Icon(Icons.chat),
        selectedIcon: Icon(Icons.chat_bubble),
        label: Text('Chats'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.group_outlined),
        selectedIcon: Icon(Icons.group),
        label: Text('Contatos'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: Text('Ajustes'),
      ),
    ];

    final effectiveIndex = widget.selectedIndex ?? _selectedIndex;

    return NavigationRail(
      selectedIndex: effectiveIndex,
      onDestinationSelected: (int index) {
        // Se o pai está controlando o índice, não atualizamos o estado interno
        // aqui — apenas chamamos o callback. Caso contrário, atualizamos.
        if (widget.selectedIndex == null) {
          setState(() {
            _selectedIndex = index;
          });
        }
        widget.onDestinationSelected?.call(index);
      },
      // Se `leading`/`trailing` foram passados pelo pai, use-os; caso
      // contrário, exiba nada nesses slots.
      leading: widget.leading ?? const SizedBox(),
      trailing: widget.trailing ?? const SizedBox(),
      labelType: NavigationRailLabelType.all,
      destinations: dests,
    );
  }
}