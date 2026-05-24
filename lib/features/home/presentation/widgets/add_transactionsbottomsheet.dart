import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:zyboexpensetracker/features/auth/presentation/widgets/bouncing_dots_loader.dart';
import 'package:zyboexpensetracker/features/auth/presentation/widgets/snackbars.dart';
import 'package:zyboexpensetracker/features/home/data/models/local_transactionmodel.dart';
import 'package:zyboexpensetracker/features/home/presentation/bloc/home_bloc.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  bool _isExpense = true;
  String? _selectedCategoryName;
  String? _selectedCategoryId;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  bool _isSubmitting = false;
  List<Map<String, dynamic>> _cachedCategories = [];

 

  static const _bg = Color(0xFF1C1C1E);
  static const _surface = Color(0xFF2C2C2E);
  static const _green = Color(0xFF34C759);
  static const _blue = Color(0xFF3D3DE8);
  static const _textPrimary = Color(0xFFFFFFFF);
  static const _textSecondary = Color(0xFF8E8E93);
  static const _infoBg = Color(0xFF1E2A1E);
  static const _infoBorder = Color(0xFF2E4A2E);
  static const _infoText = Color(0xFF86C986);

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 24 + bottomInset),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (_isSubmitting) {
            if (state is HomeError) {
              _isSubmitting = false;
              showAwesomeSnackbar(
                context: context,
                type: SnackbarType.error,
                title: 'Failed',
                message: 'Failed to add transaction. Please try again.',
              );
              Navigator.pop(context);
            } else if (state is HomeLoaded) {
              _isSubmitting = false;
              showAwesomeSnackbar(
                context: context,
                type: SnackbarType.success,
                title: 'Success',
                message: 'Transaction added successfully!',
              );
              Navigator.pop(context);
            }
          }
        },
        builder: (context, state) {
     

          if (state is HomeLoaded) {
            _cachedCategories = state.categoriesList;
          }
          if (_selectedCategoryId == null && _cachedCategories.isNotEmpty) {
            _selectedCategoryId = _cachedCategories.first['id'];
            _selectedCategoryName = _cachedCategories.first['name'];
          }

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildToggle(),
                const SizedBox(height: 16),
                _buildTextField(controller: _titleController, hint: 'Title'),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _amountController,
                  hint: 'Amount  (₹)',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                ),
                const SizedBox(height: 20),
                _buildCategorySection(_cachedCategories),
                const SizedBox(height: 16),
                _buildInfoNote(),
                const SizedBox(height: 24),
                _buildSaveButton(context),
                const SizedBox(height: 8),

                Center(
                  child: Container(
                    width: 134,
                    height: 5,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: _textSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Add Transaction',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text(
            'Close',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _toggleButton('Expense', true),
          _toggleButton('Income', false),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, bool isExpense) {
    final isSelected = _isExpense == isExpense;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isExpense = isExpense),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected
                ? (isExpense ? _green : _blue)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : _textSecondary,
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: _textPrimary, fontSize: 16),
      cursorColor: _blue,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _textSecondary, fontSize: 16),
        filled: true,
        fillColor: _surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _blue, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCategorySection(List<Map<String, dynamic>> dbCategories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CATEGORY',
          style: TextStyle(
            color: _textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        dbCategories.isEmpty
            ? Text(
                'No categories available. Please add one in Profile.',
                style: TextStyle(color: Colors.redAccent, fontSize: 14),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: dbCategories.map((cat) {
                    return _categoryChip(
                      cat['id'] as String,
                      cat['name'] as String,
                    );
                  }).toList(),
                ),
              ),
      ],
    );
  }

  Widget _categoryChip(String id, String name) {
    final isSelected = _selectedCategoryId == id;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedCategoryId = id;
        _selectedCategoryName = name;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _blue : _textSecondary.withOpacity(0.4),
            width: 1.2,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : _textSecondary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _infoBg,
        border: Border.all(color: _infoBorder, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: _infoText, size: 18),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Everything you add here is saved only on your device.',
              style: TextStyle(color: _infoText, fontSize: 13.5, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _blue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          final title = _titleController.text.trim();
          final amountText = _amountController.text.trim();

          if (title.isEmpty || amountText.isEmpty) {
            showAwesomeSnackbar(
              context: context,
              type: SnackbarType.error,
              title: 'Missing Info',
              message: 'Please fill in both Title and Amount.',
            );
            return;
          }
          final amount = double.tryParse(amountText);

          if (amount == null || amount <= 0) {
            showAwesomeSnackbar(
              context: context,
              type: SnackbarType.error,
              title: 'Invalid Amount',
              message: 'Please enter a valid positive number.',
            );
            return;
          }

          if (_selectedCategoryId == null || _selectedCategoryName == null) {
            showAwesomeSnackbar(
              context: context,
              type: SnackbarType.error,
              title: 'No Category',
              message: 'Please select a category first.',
            );
            return;
          }

          setState(() => _isSubmitting = true);

          final newTransaction = LocalTransactionmodel(
            id: const Uuid().v4(),
            amount: amount,
            note: title,
            type: _isExpense ? 'debit' : 'credit',
            categoryName: _selectedCategoryName!,
            timestamp: DateTime.now(),
          );

          context.read<HomeBloc>().add(
            AddTransactionEvent(
              transaction: newTransaction,
              categoryId: _selectedCategoryId!,
            ),
          );
        
        },
        child: _isSubmitting
            ? BouncingDotsLoader()
            : const Text(
                'Save',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }
}
