import 'package:injector/injector.dart';
import 'package:mobile_sev2/app/infrastructures/di/controller_module.dart';
import 'package:mobile_sev2/app/infrastructures/di/db_module.dart';
import 'package:mobile_sev2/app/infrastructures/di/mapper_module.dart';
import 'package:mobile_sev2/app/infrastructures/di/presenter_module.dart';
import 'package:mobile_sev2/app/infrastructures/di/repository_module.dart';
import 'package:mobile_sev2/app/infrastructures/di/root_module.dart';
import 'package:mobile_sev2/app/infrastructures/di/use_case_module.dart';

class AppComponent {
  static Future<void> init() async {
    Injector injector = getInjector();
    await DBModule.init(injector);
    await RootModule.init(injector);
    MapperModule.init(injector);
    RepositoryModule.init(injector);
    UseCaseModule.init(injector);
    PresenterModule.init(injector);
    ControllerModule.init(injector);
  }

  static Future<void> refresh() async {
    getInjector().clearAll();
    await init();
  }

  static Injector getInjector() {
    return Injector.appInstance;
  }
}
