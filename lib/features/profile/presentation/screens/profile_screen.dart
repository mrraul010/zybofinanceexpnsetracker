import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyboexpensetracker/features/auth/presentation/screens/login_screen.dart';
import 'package:zyboexpensetracker/features/auth/presentation/widgets/snackbars.dart';
import 'package:zyboexpensetracker/features/home/presentation/bloc/home_bloc.dart';
import 'package:zyboexpensetracker/features/home/presentation/synctocloudbloc/bloc/syncto_cloud_bloc.dart';
import 'package:zyboexpensetracker/features/profile/presentation/widgets/error_view.dart';
import 'package:zyboexpensetracker/features/profile/presentation/widgets/profile_shimmer.dart';
import 'package:zyboexpensetracker/features/profile/presentation/widgets/syncloading_animationbutton.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _alertController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  double _currentLimit = 1000;
  bool _isEditingNickname = false;

  final List<String> _categories = ['Food', 'Bills', 'Transport', 'Shopping'];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nicknameController.text = prefs.getString('user_nickname') ?? 'User';
      _currentLimit = prefs.getDouble('budget_limit') ?? 1000.0;
      _alertController.text = _currentLimit.toStringAsFixed(0);
    });
  }

  Future<void> _saveNickname(String newName) async {
    if (newName.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_nickname', newName.trim());

    if (!mounted) return;

    context.read<HomeBloc>().add(FetchHomeDashboardData());
  }

  Future<void> _saveBudgetLimit(double limit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('budget_limit', limit);

    if (!mounted) return;

    context.read<HomeBloc>().add(FetchHomeDashboardData());
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _alertController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return ProfileShimmer();
            }
            if (state is HomeLoaded) {
              final dbcategories = state.categoriesList;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocListener<SynctoCloudBloc, SynctoCloudState>(
                  listenWhen: (previous, current) => previous != current,
                  listener: (context, syncState) {
                    if (syncState is SynctoCloudSucess) {
                      context.read<HomeBloc>().add(FetchHomeDashboardData());

                      showAwesomeSnackbar(
                        context: context,
                        type: SnackbarType.success,
                        title: 'Sync Complete',
                        message: 'Your data has been securely backed up.',
                      );
                    }

                    if (syncState is SynctoCloudFailure) {
                      context.read<HomeBloc>().add(FetchHomeDashboardData());
                      showAwesomeSnackbar(
                        context: context,
                        type: SnackbarType.success,
                        title: 'Sync Complete',
                        message: 'Your data has been securely backed up.',
                      );
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      const Text(
                        'Profile & Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 28),

                      _sectionLabel('NICKNAME'),
                      const SizedBox(height: 10),
                      _nicknameCard(),
                      const SizedBox(height: 24),

                      _alertLimitCard(),
                      const SizedBox(height: 24),

                      _sectionLabel('CATEGORIES'),
                      const SizedBox(height: 10),
                      _categoriesCard(dbcategories),
                      const SizedBox(height: 24),

                      _sectionLabel('CLOUD SYNC'),
                      const SizedBox(height: 10),
                      BlocBuilder<SynctoCloudBloc, SynctoCloudState>(
                        builder: (context, synctocloudState) {
                          if (synctocloudState is SynctoCloudInProgress) {
                            return SyncLoadingAnimationButton();
                          }
                          return _cloudSyncCard(synctocloudState);
                        },
                      ),

                      const SizedBox(height: 16),

                      _logoutButton(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              );
            }
            if (state is HomeError) {
              return ErrorView(
                message: state.errorMessage,
                onRetry: () =>
                    context.read<HomeBloc>().add(FetchHomeDashboardData()),
              );
            }

            return ErrorView(
              message:
                  'Something went wrong on our end. Were looking into it! Please try again shortly. title for this',
              onRetry: () =>
                  context.read<HomeBloc>().add(FetchHomeDashboardData()),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF888888),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.3,
      ),
    );
  }

  Widget _nicknameCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _isEditingNickname
                ? TextField(
                    controller: _nicknameController,
                    autofocus: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (value) {
                      setState(() => _isEditingNickname = false);
                      _saveNickname(value);
                    },
                  )
                : Text(
                    _nicknameController.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          GestureDetector(
            onTap: () {
              if (_isEditingNickname) {
                _saveNickname(_nicknameController.text);
              }
              setState(() => _isEditingNickname = !_isEditingNickname);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF333333), width: 1),
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _alertLimitCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('ALERT LIMIT (₹)'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252525),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _alertController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Amount  (₹)',
                      hintStyle: TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 15,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  final val = double.tryParse(_alertController.text);
                  if (val != null) {
                    setState(() => _currentLimit = val);
                    _saveBudgetLimit(val);
                  }
                  showAwesomeSnackbar(
                    context: context,
                    type: SnackbarType.success,
                    title: 'All set!',
                    message: 'Weve saved the changes to your budget limit',
                  );
                },
                child: Container(
                  height: 48,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B3FE4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Set',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Current Limit: ₹${_formatAmount(_currentLimit)}',
            style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _categoriesCard(List<Map<String, dynamic>> dbCategories) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252525),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _categoryController,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'New category Name',
                      hintStyle: TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 15,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  final name = _categoryController.text.trim();
                  if (name.isNotEmpty) {
                    final bool exists = dbCategories.any(
                      (cat) =>
                          cat['name'].toString().toLowerCase() ==
                          name.toLowerCase(),
                    );

                    if (!exists) {
                      context.read<HomeBloc>().add(AddCategoryEvent(name));
                      _categoryController.clear();
                    } else {
                      showAwesomeSnackbar(
                        context: context,
                        type: SnackbarType.info,
                        title: 'Category already exists!',
                        message:
                            'The category you are trying to create already exists in the system',
                      );
                    }
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B3FE4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          dbCategories.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    "No categories found",
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dbCategories.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Color(0xFF242424), height: 1),
                  itemBuilder: (context, index) {
                    final category = dbCategories[index];

                    final String categoryId = category['id'] as String;
                    final String categoryName = category['name'] as String;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              categoryName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<HomeBloc>().add(
                                DeleteCategoryEvent(categoryId),
                              );
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A1515),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: Color(0xFFEF4444),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _cloudSyncCard(SynctoCloudState state) {
    Color cardColor = const Color(0xFF4B3FE4);
    String mainText = 'Sync To Cloud';
    String subText = 'Sync and update data to the backend';
    IconData icon = Icons.cloud_upload_rounded;

    if (state is SynctoCloudSucess) {
      cardColor = const Color(0xFF22C55E);
      mainText = 'Resync';
      subText = 'All data is securely backed up';
      icon = Icons.check_circle_outline_rounded;
    } else if (state is SynctoCloudFailure) {
      cardColor = const Color(0xFFEF4444);
      mainText = 'Resync';
      subText = 'Sync failed. Tap to try again.';
      icon = Icons.error_outline_rounded;
    }

    return GestureDetector(
      onTap: () {
        context.read<SynctoCloudBloc>().add(StartCloudSync());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mainText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subText,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(icon, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        if (!mounted) return;

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Log Out',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.power_settings_new_rounded,
              color: Color(0xFFEF4444),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return amount
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return amount.toStringAsFixed(0);
  }
}
