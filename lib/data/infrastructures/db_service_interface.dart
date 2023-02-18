abstract class DBServiceInterface {
  findAll(String key, dynamic argument);
  findOne(String key);
  insert(String key, dynamic argument);
  update(String key, dynamic argument);
  delete(String key);
}
