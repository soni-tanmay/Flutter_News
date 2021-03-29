abstract class HiveStoreContract {
  Future insertObjects(
    String boxName,
    Map<String, dynamic> keyValues,
  );

  Future<List<Map<String, dynamic>>> readObjects(
    String boxName, {
    List<String> keys,
  });

  Future updateObjects(
    String boxName,
    Map<String, dynamic> keyValues,
  );

  Future deleteObjects(
    String boxName, {
    List<String> keys,
  });

  Future<bool> clearBox(String boxName);
}
