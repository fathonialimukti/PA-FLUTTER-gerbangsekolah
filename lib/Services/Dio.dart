import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String baseUrl = "https://www.gerbangsekolah.online/";
const String meetUrl = "https://ruangkelas.gerbangsekolah.online/";

Dio dio() {
  Dio dio = new Dio();

  dio.options.baseUrl = baseUrl + "api/";

  dio.options.headers['accept'] = 'Application/Json';

  dio.interceptors.add(PrettyDioLogger());

  return dio;
}
