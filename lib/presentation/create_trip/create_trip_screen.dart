import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_packer/presentation/create_trip/create_trip_view_model.dart';
import 'package:trip_packer/domain/entities/trip.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 3));
  TripType _selectedType = TripType.city;

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createTripViewModelProvider);

    ref.listen<AsyncValue<void>>(createTripViewModelProvider, (prev, next) {
      if (next.hasError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('Новая поездка')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Название'),
                validator: (v) => v!.isEmpty ? 'Введите название' : null,
              ),
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(labelText: 'Город'),
                validator: (v) => v!.isEmpty ? 'Введите город' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TripType>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Тип поездки'),
                items: TripType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
              ),
              ListTile(
                title: Text('Начало: ${_startDate.day}.${_startDate.month}.${_startDate.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) setState(() => _startDate = date);
                },
              ),
              ListTile(
                title: Text('Конец: ${_endDate.day}.${_endDate.month}.${_endDate.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _endDate,
                    firstDate: _startDate,
                    lastDate: _startDate.add(Duration(days: 30)),
                  );
                  if (date != null) setState(() => _endDate = date);
                },
              ),
              SizedBox(height: 20),
              if (createState.isLoading) CircularProgressIndicator(),
              ElevatedButton(
                onPressed: createState.isLoading ? null : () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await ref.read(createTripViewModelProvider.notifier)
                        .submitTrip(_nameController.text, _destinationController.text, _startDate, _endDate, _selectedType);
                    if (success && mounted) {
                      Navigator.pop(context, true);
                    }
                  }
                },
                child: Text('Создать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}