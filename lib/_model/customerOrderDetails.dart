import 'package:basket/_model/coupons.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/_model/orders.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/_model/regions.dart';

class CustomerOrderDetails{
  orders _customerOrder;
  regions _customerRegions;
  coupons _customerCoupons;
  customers customer;
  bool _hasCoupon = false;
  double _valueAddedTaxes;
  List<Product> _orderProducts = <Product>[];


  CustomerOrderDetails({customers,customerOrder, customerRegions,
      customerCoupons, hasCoupon, valueAddedTaxes,
     orderProducts});

  orders get customerOrder => _customerOrder;

  set customerOrder(orders value) {
    _customerOrder = value;
  }

  regions get customerRegions => _customerRegions;

  set customerRegions(regions value) {
    _customerRegions = value;
  }

  coupons get customerCoupons => _customerCoupons;

  set customerCoupons(coupons value) {
    _customerCoupons = value;
  }

  bool get hasCoupon => _hasCoupon;

  set hasCoupon(bool value) {
    _hasCoupon = value;
  }

  double get valueAddedTaxes => _valueAddedTaxes;

  set valueAddedTaxes(double value) {
    _valueAddedTaxes = value;
  }

  List<Product> get orderProducts => _orderProducts;

  set orderProducts(List<Product> value) {
    _orderProducts = value;
  }


}