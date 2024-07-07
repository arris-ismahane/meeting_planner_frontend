abstract class BasicEntity {
  final int id;

  final int creationDate;
  final int lastUpdate;

  BasicEntity(this.id, this.creationDate, this.lastUpdate);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) {
      return false;
    }
    var _other = (other as BasicEntity);

    return _other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
