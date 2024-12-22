import 'package:clothes_app/models/clothes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ClothesService {
  
  final CollectionReference _clothesCollection =
      FirebaseFirestore.instance.collection('clothes');

    Stream<List<Clothes>> fetchClothes() {
    return _clothesCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Clothes.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

 Future<bool> addClothes(Clothes clothes) async {
    try {
      await _clothesCollection.add(clothes.toMap()); // Adsqued clothes to Firestore
      return true; // Return true on success
    } catch (e) {
      return false; // Return false if an error occurs
    }
  }
 


  Future<void> updateClothes(String id, Clothes clothes) async {
    try {
      await _clothesCollection.doc(id).update(clothes.toMap());
    } catch (e) {
      throw Exception('Failed to update clothes: $e');
    }
  }

  Future<void> deleteClothes(String id) async {
    try {
      await _clothesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete clothes: $e');
    }
  }
}
