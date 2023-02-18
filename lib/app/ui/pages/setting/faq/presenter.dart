import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/faq/get_faqs_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/faq_request_interface.dart';
import 'package:mobile_sev2/domain/faq.dart';
import 'package:mobile_sev2/use_cases/faq/get_faqs.dart';

class FaqPresenter extends Presenter {
  GetFaqsUseCase _faqsUseCase;

  FaqPresenter(this._faqsUseCase);

  // get faqs
  late Function getFaqsOnNext;
  late Function getFaqsOnComplete;
  late Function getFaqsOnError;

  void onGetFaqs(GetFaqsRequestInterface req) {
    if (req is GetFaqsApiRequest) {
      _faqsUseCase.execute(_GetFaqsObserver(this, PersistenceType.api), req);
    }
  }

  @override
  void dispose() {
    _faqsUseCase.dispose();
  }
}

class _GetFaqsObserver implements Observer<List<Faq>> {
  FaqPresenter _presenter;
  PersistenceType _type;

  _GetFaqsObserver(this._presenter, this._type);

  void onNext(List<Faq>? faqs) {
    _presenter.getFaqsOnNext(faqs, _type);
  }

  void onComplete() {
    _presenter.getFaqsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getFaqsOnError(e, _type);
  }
}
