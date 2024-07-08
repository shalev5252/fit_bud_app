
class Equipment_counter {
  String name;
  int quantity;
  Equipment_counter(this.name, this.quantity);
}

class Equipment_summary {
  String name;
  int quantity_in_storage;
  int quantity_in_use;
  Equipment_summary(this.name, this.quantity_in_storage, this.quantity_in_use);
}