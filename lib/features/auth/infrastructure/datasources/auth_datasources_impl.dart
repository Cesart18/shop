import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/domain/datasources/auth_datasource.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';



  
//   class ErrorInterceptor extends Interceptor{
//   @override
//   void onResponse( Response response, ResponseInterceptorHandler handler ){
//     final status = response.statusCode;
//     final isValid = status != null && status >= 200 && status < 300;
//     if( isValid ){
//       throw DioException.badResponse(
//         statusCode: status,
//          requestOptions: response.requestOptions,
//           response: response);
//     }
//   }
// }
class AuthDatasourceImpl extends AuthDatasource{

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      contentType: Headers.jsonContentType,
    
      // validateStatus: (status) {
      //   return status != null;
      // },
    ),
    
  );
  
  @override
  Future<User> checkAuthStatus(String token) async {
    // dio.interceptors.addAll([ErrorInterceptor()]);
    try {
      final response = await dio.get('/auth/check-status',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token'
          }
        ));
        final user = UserMapper.userJsonToEntity(response.data);
        return user;

    } on DioException catch (e) {
      if(e.type == DioExceptionType.badResponse){
        throw CustomError(message: 'Token incorrecto');
      }
      if(e.type == DioExceptionType.connectionTimeout){
        throw CustomError(message: 'Revisar conexion a internet');
      }
      throw Exception();
    } catch (e){
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async{
      
      try{
        final response = await dio.post('/auth/login', data: {
          "email": email,
          "password": password,
        });
        final user = UserMapper.userJsonToEntity(response.data);
        return user;

      } on DioException catch (e) {
        
      if(e.type == DioExceptionType.badResponse){
        throw CustomError(message: e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if(e.type == DioExceptionType.connectionTimeout){
        throw CustomError(message: 'Revisar conexion a internet');
      }
      throw Exception();
    }catch (e){
      throw Exception();
    }


  }

  @override
  Future<User> register(String email, String password, String fullName) async{

      try {
        final response = await dio.post('/auth/register',data: {
          'email': email,
          'password':password,
          'fullName':fullName
        });
        final user = UserMapper.userJsonToEntity(response.data);
        return user;
        
      }  on DioException catch (e) {
      if(e.response?.statusCode == 400){
        throw CustomError(message: e.response?.data['message'] ?? 'Usuario ya existe');
      }
      if(e.type == DioExceptionType.connectionTimeout){
        throw CustomError(message: 'Revisar conexion a internet');
      }
      throw Exception();
    }catch (e){
      throw Exception();
    }
  }
}