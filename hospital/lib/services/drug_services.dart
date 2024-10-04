import 'package:hospital/model/drug_model.dart';

class DrugService {
  static List<Drug> getDrugs() {
    return [
      Drug(
          id: 1,
          name: 'Arsenic trioxide',
          diluent: 'NS or D5W',
          volume: '100-250mL'),
      Drug(id: 2, name: 'Asparginase', diluent: 'NS', volume: '100mL'),
      Drug(id: 3, name: 'Bevacizumab', diluent: 'NS', volume: '100mL'),
      Drug(id: 4, name: 'Bleomycin', diluent: 'NS', volume: '50-100mL'),
      Drug(id: 5, name: 'Carfilzomib', diluent: 'D5W', volume: '50-100mL'),
      Drug(
          id: 6,
          name: 'Cisplatin',
          diluent: 'NS or D5W or 0.45% NS',
          volume: '250-1000mL'),
      Drug(
          id: 7,
          name: 'Cytarabine',
          diluent: 'NS or D5W',
          volume: '500-1000mL'),
      Drug(
          id: 8, name: 'Dacarbazine', diluent: 'NS or D5W', volume: '50-250mL'),
      Drug(id: 9, name: 'Daunorubicin', diluent: 'NS', volume: '10-15mL'),
      Drug(id: 10, name: 'Doxorubicin', diluent: 'NS or D5W', volume: '100mL'),
    ];
  }
}
