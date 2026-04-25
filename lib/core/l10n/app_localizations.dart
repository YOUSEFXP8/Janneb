import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

class AppLocalizations {
  final bool _isAr;
  AppLocalizations(this._isAr);

  static AppLocalizations of(BuildContext context) {
    final provider = context.read<LocaleProvider>();
    return AppLocalizations(provider.isArabic);
  }

  // ── App ────────────────────────────────────────────────────────────────────
  String get appName => 'Janneb';
  String get appTagline => _isAr ? 'بلّغ عن الحوادث بسرعة وأمان' : 'Report accidents quickly and safely';

  // ── Onboarding ─────────────────────────────────────────────────────────────
  String get onboardingTitle1 => _isAr ? 'الإبلاغ عن الحوادث بسهولة' : 'Report Accidents Easily';
  String get onboardingDesc1 => _isAr
      ? 'أبلّغ عن حوادث السيارات ببضع نقرات. التقط الأدلة وشارك موقعك وأرسل تقريرك في دقائق.'
      : 'Quickly report car accidents with just a few taps. Capture evidence, share location, and submit your report in minutes.';
  String get onboardingTitle2 => _isAr ? 'التقط الأدلة' : 'Capture Evidence';
  String get onboardingDesc2 => _isAr
      ? 'التقط صورًا لمشهد الحادث وأضرار المركبة وأي تفاصيل ذات صلة لدعم تقريرك.'
      : 'Take photos of the accident scene, vehicle damage, and any relevant details to support your report.';
  String get onboardingTitle3 => _isAr ? 'احصل على المساعدة بسرعة' : 'Get Help Fast';
  String get onboardingDesc3 => _isAr
      ? 'تواصل مع خدمات الطوارئ وتابع حالة تقريرك في الوقت الفعلي. المساعدة دائمًا على بُعد نقرة.'
      : 'Connect with emergency services and track your report status in real-time. Help is always just a tap away.';
  String get skip => _isAr ? 'تخطي' : 'Skip';
  String get next => _isAr ? 'التالي' : 'Next';
  String get getStarted => _isAr ? 'ابدأ الآن' : 'Get Started';

  // ── Auth – Login ───────────────────────────────────────────────────────────
  String get welcomeBack => _isAr ? 'مرحبًا بعودتك' : 'Welcome Back';
  String get signInToAccount => _isAr ? 'تسجيل الدخول إلى حسابك' : 'Sign in to your account';
  String get email => _isAr ? 'البريد الإلكتروني' : 'Email';
  String get enterEmail => _isAr ? 'أدخل بريدك الإلكتروني' : 'Enter your email';
  String get password => _isAr ? 'كلمة المرور' : 'Password';
  String get enterPassword => _isAr ? 'أدخل كلمة المرور' : 'Enter your password';
  String get login => _isAr ? 'تسجيل الدخول' : 'Login';
  String get dontHaveAccount => _isAr ? 'ليس لديك حساب؟ ' : "Don't have an account? ";
  String get signUp => _isAr ? 'إنشاء حساب' : 'Sign Up';
  String get incorrectCredentials => _isAr
      ? 'بريد إلكتروني أو كلمة مرور غير صحيحة. حاول مجددًا.'
      : 'Incorrect email or password. Please try again.';
  String get noAccountFound => _isAr
      ? 'لا يوجد حساب بهذا البريد الإلكتروني.'
      : 'No account found with this email.';
  String get connectionError => _isAr
      ? 'خطأ في الاتصال. تحقق من الإنترنت وحاول مجددًا.'
      : 'Connection error. Check your internet and try again.';

  // ── Auth – Signup ──────────────────────────────────────────────────────────
  String get createAccount => _isAr ? 'إنشاء حساب' : 'Create Account';
  String get signUpWithEmail => _isAr ? 'سجّل باستخدام بريدك الإلكتروني' : 'Sign up with your email address';
  String get createPassword => _isAr ? 'أنشئ كلمة مرور' : 'Create a password';
  String get confirmPassword => _isAr ? 'تأكيد كلمة المرور' : 'Confirm Password';
  String get reEnterPassword => _isAr ? 'أعد إدخال كلمة المرور' : 'Re-enter your password';
  String get alreadyHaveAccount => _isAr ? 'لديك حساب بالفعل؟ ' : 'Already have an account? ';
  String get accountAlreadyExists => _isAr
      ? 'يوجد حساب بهذا البريد الإلكتروني بالفعل.'
      : 'An account with this email already exists.';
  String get strengthWeak => _isAr ? 'ضعيفة' : 'Weak';
  String get strengthFair => _isAr ? 'مقبولة' : 'Fair';
  String get strengthGood => _isAr ? 'جيدة' : 'Good';
  String get strengthStrong => _isAr ? 'قوية' : 'Strong';
  String get reqLength => _isAr ? 'على الأقل 8 أحرف' : 'At least 8 characters';
  String get reqUppercase => _isAr ? 'حرف كبير (A–Z)' : 'Uppercase letter (A–Z)';
  String get reqNumber => _isAr ? 'رقم (0–9)' : 'Number (0–9)';
  String get reqSpecial => _isAr ? 'رمز خاص (!@#…)' : 'Special character (!@#…)';
  String get passwordsDoNotMatch => _isAr ? 'كلمتا المرور غير متطابقتين' : 'Passwords do not match';
  String get pleaseConfirmPassword => _isAr ? 'يرجى تأكيد كلمة المرور' : 'Please confirm your password';

  // ── Auth – Complete Profile ────────────────────────────────────────────────
  String get completeProfile => _isAr ? 'أكمل ملفك الشخصي' : 'Complete Your Profile';
  String get tellUsAboutYourself => _isAr ? 'أخبرنا بمعلوماتك' : 'Tell us a bit about yourself';
  String get nationalId => _isAr ? 'رقم الهوية الوطنية' : 'National ID';
  String get enterNationalId => _isAr ? 'أدخل رقم هويتك الوطنية' : 'Enter your national ID number';
  String get fullName => _isAr ? 'الاسم الكامل' : 'Full Name';
  String get enterFullName => _isAr ? 'أدخل اسمك الكامل' : 'Enter your full name';
  String get phoneNumber => _isAr ? 'رقم الهاتف' : 'Phone Number';
  String get dateOfBirth => _isAr ? 'تاريخ الميلاد' : 'Date of Birth';
  String get selectDateOfBirth => _isAr ? 'اختر تاريخ ميلادك' : 'Select your date of birth';
  String get gender => _isAr ? 'الجنس' : 'Gender';
  String get male => _isAr ? 'ذكر' : 'Male';
  String get female => _isAr ? 'أنثى' : 'Female';
  String get continueBtn => _isAr ? 'متابعة' : 'Continue';
  String get nationalIdRequired => _isAr ? 'رقم الهوية مطلوب' : 'National ID is required';
  String get nationalIdNumeric => _isAr ? 'يجب أن يكون رقم الهوية أرقامًا فقط' : 'National ID must be numeric';
  String get dateOfBirthRequired => _isAr ? 'تاريخ الميلاد مطلوب' : 'Date of birth is required';
  String get selectDateOfBirthMsg => _isAr ? 'الرجاء اختيار تاريخ ميلادك' : 'Please select your date of birth';
  String get selectGenderMsg => _isAr ? 'الرجاء اختيار الجنس' : 'Please select your gender';

  // ── Auth – Car List ────────────────────────────────────────────────────────
  String get yourVehicles => _isAr ? 'مركباتك' : 'Your Vehicles';
  String get registerVehicleToStart => _isAr ? 'سجّل مركبة واحدة على الأقل للمتابعة' : 'Register at least one vehicle to continue';
  String get noVehiclesAdded => _isAr ? 'لم تتم إضافة مركبات بعد' : 'No vehicles added yet';
  String get addCar => _isAr ? 'إضافة سيارة' : 'Add Car';
  String get finishSetup => _isAr ? 'إنهاء الإعداد' : 'Finish Setup';

  // ── Auth – Add Car ─────────────────────────────────────────────────────────
  String get addVehicle => _isAr ? 'إضافة مركبة' : 'Add Vehicle';
  String get vinNumber => _isAr ? 'رقم الهيكل (VIN)' : 'VIN Number';
  String get enterVin => _isAr ? 'أدخل رقم تعريف المركبة' : 'Enter vehicle identification number';
  String get plateNumber => _isAr ? 'رقم اللوحة' : 'Plate Number';
  String get enterPlate => _isAr ? 'أدخل رقم اللوحة' : 'Enter plate number';
  String get manufacturer => _isAr ? 'الشركة المصنعة' : 'Manufacturer';
  String get manufacturerHint => _isAr ? 'مثل: تويوتا، هوندا' : 'e.g. Toyota, Honda';
  String get color => _isAr ? 'اللون' : 'Color';
  String get colorHint => _isAr ? 'مثل: أبيض، أسود' : 'e.g. White, Black';
  String get registrationType => _isAr ? 'نوع التسجيل' : 'Registration Type';
  String get registrationTypeHint => _isAr ? 'مثل: خاص، تجاري' : 'e.g. Private, Commercial';
  String get carType => _isAr ? 'نوع السيارة' : 'Car Type';
  String get carTypeHint => _isAr ? 'مثل: سيدان، SUV، شاحنة' : 'e.g. Sedan, SUV, Truck';
  String get year => _isAr ? 'السنة' : 'Year';
  String get yearHint => _isAr ? 'مثل: 2022' : 'e.g. 2022';
  String get insuranceCompany => _isAr ? 'شركة التأمين' : 'Insurance Company';
  String get enterInsuranceCompany => _isAr ? 'أدخل اسم شركة التأمين' : 'Enter insurance company name';
  String get insuranceId => _isAr ? 'رقم وثيقة التأمين' : 'Insurance ID';
  String get enterInsuranceId => _isAr ? 'أدخل رقم وثيقة التأمين' : 'Enter insurance policy number';
  String get saveCar => _isAr ? 'حفظ السيارة' : 'Save Car';

  // ── Home ───────────────────────────────────────────────────────────────────
  String get hello => _isAr ? 'مرحبًا' : 'Hello';
  String get locationPlaceholder => _isAr ? 'عمّان، الأردن' : 'Amman, Jordan';
  String get needToReportAccident => _isAr ? 'هل تحتاج إلى الإبلاغ عن حادث؟' : 'Need to report an accident?';
  String get quicklyFileReport => _isAr ? 'أبلّغ بسرعة مع الصور والموقع والتفاصيل.' : 'Quickly file a report with photos, location, and details.';
  String get reportAccident => _isAr ? 'بلّغ عن حادث' : 'Report Accident';
  String get quickActions => _isAr ? 'الإجراءات السريعة' : 'Quick Actions';
  String get myReports => _isAr ? 'تقاريري' : 'My Reports';
  String get emergencyCall => _isAr ? 'اتصال طوارئ' : 'Emergency Call';
  String get help => _isAr ? 'مساعدة' : 'Help';
  String get insurance => _isAr ? 'التأمين' : 'Insurance';
  String get recentReports => _isAr ? 'أحدث التقارير' : 'Recent Reports';
  String get noReportsYet => _isAr ? 'لا توجد تقارير بعد' : 'No reports yet';
  String get reportsWillAppear => _isAr ? 'ستظهر تقارير الحوادث هنا' : 'Your accident reports will appear here';

  // ── Emergency ──────────────────────────────────────────────────────────────
  String get emergencyAssistance => _isAr ? 'المساعدة الطارئة' : 'Emergency Assistance';
  String get tapToCallImmediately => _isAr ? 'اضغط للاتصال فورًا' : 'Tap to call immediately';
  String get onlyForEmergencies => _isAr ? 'للاستخدام في الحالات الطارئة فقط' : 'Only use in genuine emergencies';
  String get callPolice => _isAr ? 'اتصل بالشرطة' : 'Call Police';
  String get callAmbulance => _isAr ? 'اتصل بالإسعاف' : 'Call Ambulance';
  String couldNotOpenPhone(String number) =>
      _isAr ? 'تعذّر فتح تطبيق الهاتف للرقم $number' : 'Could not open phone app for $number';

  // ── QR Session ─────────────────────────────────────────────────────────────
  String get accidentSession => _isAr ? 'جلسة الحادث' : 'Accident Session';
  String get createSessionDesc => _isAr
      ? 'أنشئ كود جلسة جديدًا لمشاركته مع الطرف الآخر، أو امسح/أدخل كوده للانضمام.'
      : 'Create a new session code to share with the other party, or scan/enter their code to join.';
  String get joinCode => _isAr ? 'كود الانضمام' : 'Join Code';
  String get shareQrDesc => _isAr
      ? 'شارك رمز الاستجابة السريع أو الكود مع السائق الآخر.'
      : 'Share this QR code or the join code with the other driver.';
  String get continueToEvidence => _isAr ? 'متابعة لالتقاط الأدلة' : 'Continue to Evidence';
  String get joinAccidentSession => _isAr ? 'الانضمام إلى جلسة حادث' : 'Join an Accident Session';
  String get scanQrCode => _isAr ? 'مسح رمز QR' : 'Scan QR Code';
  String get enterJoinCode => _isAr ? 'أدخل كود الانضمام' : 'Enter join code';
  String get joinCodeHint => _isAr ? 'مثل: 847291' : 'e.g. 847291';
  String get joinSession => _isAr ? 'الانضمام إلى الجلسة' : 'Join Session';
  String get createSession => _isAr ? 'إنشاء جلسة' : 'Create Session';
  String get codeCopied => _isAr ? 'تم نسخ الكود' : 'Code copied to clipboard';
  String get copyCode => _isAr ? 'نسخ الكود' : 'Copy code';
  String get or => _isAr ? 'أو' : 'OR';
  String get invalidJoinCode => _isAr ? 'كود انضمام غير صالح' : 'Invalid join code';
  String get alreadyLinked => _isAr ? 'أنت مرتبط بالفعل بهذا الحادث' : 'You are already linked to this accident';
  String get failedToJoin => _isAr ? 'فشل الانضمام إلى الجلسة' : 'Failed to join session';
  String get failedToCreate => _isAr ? 'فشل إنشاء الجلسة' : 'Failed to create session';
  String get enterJoinCodeValidation => _isAr ? 'الرجاء إدخال كود الانضمام' : 'Please enter a join code';
  String get loadingVehicles => _isAr ? 'جارٍ تحميل المركبات…' : 'Loading vehicles…';

  // ── QR Scanner ─────────────────────────────────────────────────────────────
  String get positionQrCode => _isAr ? 'ضع رمز الاستجابة السريع داخل الإطار.' : 'Position the QR code within the view.';

  // ── Capture Evidence ───────────────────────────────────────────────────────
  String get captureEvidence => _isAr ? 'التقاط الأدلة' : 'Capture Evidence';
  String get takePhotosDesc => _isAr ? 'التقط صورًا لمشهد الحادث' : 'Take photos of the accident scene';
  String get takePhoto => _isAr ? 'التقط صورة' : 'Take Photo';
  String get capturePhoto => _isAr ? 'كاميرا' : 'Capture Photo';
  String get gallery => _isAr ? 'معرض الصور' : 'Gallery';
  String get photosCaptured => _isAr ? 'الصور الملتقطة' : 'Photos Captured';
  String get continueText => _isAr ? 'متابعة' : 'Continue';
  String photosProgress(int count) =>
      _isAr ? '$count / 2 صور مطلوبة' : '$count / 2 required photos';
  String photosCapturedCount(int count) =>
      _isAr ? 'تم التقاط $count صورة' : '$count photo${count == 1 ? '' : 's'} captured';

  // ── Location ───────────────────────────────────────────────────────────────
  String get accidentLocation => _isAr ? 'موقع الحادث' : 'Accident Location';
  String get confirmLocationSubtitle => _isAr ? 'أكّد موقع الحادث' : 'Confirm the accident location';
  String get locationPermissionRequired => _isAr ? 'مطلوب إذن الموقع' : 'Location permission required';
  String get failedToGetLocation => _isAr ? 'فشل الحصول على الموقع' : 'Failed to get location';
  String get mapPlaceholder => _isAr ? 'سيتم دمج الخريطة لاحقًا' : 'Map will be integrated later';
  String get currentLocation => _isAr ? 'الموقع الحالي' : 'Current Location';
  String get refreshLocation => _isAr ? 'تحديث الموقع' : 'Refresh Location';
  String get getCurrentLocation => _isAr ? 'الحصول على الموقع الحالي' : 'Get Current Location';
  String get confirmLocation => _isAr ? 'تأكيد الموقع' : 'Confirm Location';
  String get adjustLocation => _isAr ? 'ضبط الموقع' : 'Adjust Location';

  // ── Driver Details ─────────────────────────────────────────────────────────
  String get driverDetails => _isAr ? 'تفاصيل السائق' : 'Driver Details';
  String get confirmInfoDesc => _isAr ? 'أكّد معلوماتك وتفاصيل مركبتك' : 'Confirm your information and vehicle details';
  String get yourInformation => _isAr ? 'معلوماتك' : 'Your Information';
  String get yourVehicle => _isAr ? 'مركبتك' : 'Your Vehicle';
  String get selectYourVehicle => _isAr ? 'اختر مركبتك' : 'Select Your Vehicle';
  String get noVehiclesForAccident => _isAr ? 'لا توجد مركبات مسجّلة. أضف مركبة في ملفك الشخصي.' : 'No vehicles registered. Add a vehicle in your profile.';
  String get selectVehicleHint => _isAr ? 'اختر مركبتك' : 'Select your vehicle';
  String get pleaseSelectAccidentType => _isAr ? 'الرجاء اختيار نوع الحادث' : 'Please select an accident type';
  String get accidentDescription => _isAr ? 'وصف الحادث' : 'Accident Description';
  String get describeWhatHappened => _isAr ? 'صِف ما حدث…' : 'Describe what happened…';

  // ── Review ─────────────────────────────────────────────────────────────────
  String get reviewReport => _isAr ? 'مراجعة التقرير' : 'Review Report';
  String get reviewSubtitle => _isAr ? 'راجع تقريرك قبل الإرسال' : 'Review your report before submitting';
  String get accidentSessionSection => _isAr ? 'جلسة الحادث' : 'Accident Session';
  String get sessionId => _isAr ? 'رقم الجلسة' : 'Session ID';
  String get latitude => _isAr ? 'خط العرض' : 'Latitude';
  String get longitude => _isAr ? 'خط الطول' : 'Longitude';
  String get locationLabel => _isAr ? 'الموقع' : 'Location';
  String get viewOnMap => _isAr ? 'عرض على الخريطة' : 'View on Map';
  String get make => _isAr ? 'الشركة المصنعة' : 'Make';
  String get type => _isAr ? 'النوع' : 'Type';
  String get plate => _isAr ? 'اللوحة' : 'Plate';
  String get policyId => _isAr ? 'رقم الوثيقة' : 'Policy ID';
  String get details => _isAr ? 'التفاصيل' : 'Details';
  String get accidentDetails => _isAr ? 'تفاصيل الحادث' : 'Accident Details';
  String get weather => _isAr ? 'الطقس' : 'Weather';
  String get injuries => _isAr ? 'إصابات' : 'Injuries';
  String get yes => _isAr ? 'نعم' : 'Yes';
  String get no => _isAr ? 'لا' : 'No';
  String get evidence => _isAr ? 'الأدلة' : 'Evidence';
  String get noPhotosCaptured => _isAr ? 'لم تُلتقط صور' : 'No photos captured';
  String get submit => _isAr ? 'إرسال' : 'Submit';
  String get edit => _isAr ? 'تعديل' : 'Edit';
  String get failedToSubmit => _isAr ? 'فشل إرسال التقرير. حاول مجددًا.' : 'Failed to submit report. Please try again.';
  String photosCountLabel(int n) =>
      _isAr ? 'تم التقاط $n صورة' : '$n photo${n == 1 ? '' : 's'} captured';

  // ── Success ────────────────────────────────────────────────────────────────
  String get reportSubmitted => _isAr ? 'تم إرسال التقرير بنجاح' : 'Report Submitted Successfully';
  String get successMessage => _isAr ? 'يمكنك الآن تحريك مركبتك إلى جانب الطريق' : 'You may now move your vehicle to the roadside';
  String get reportReference => _isAr ? 'رقم مرجع التقرير' : 'Report Reference';
  String get viewReport => _isAr ? 'عرض التقرير' : 'View Report';
  String get returnHome => _isAr ? 'العودة إلى الرئيسية' : 'Return Home';

  // ── My Reports ─────────────────────────────────────────────────────────────
  String get myReportsTitle => _isAr ? 'تقاريري' : 'My Reports';
  String get noReportsAvailable => _isAr ? 'لا توجد تقارير متاحة' : 'No reports available';

  // ── Report Details ─────────────────────────────────────────────────────────
  String get reportStatus => _isAr ? 'حالة التقرير' : 'Report Status';
  String get statusReported => _isAr ? 'مُبلَّغ' : 'Reported';
  String get statusUnderReview => _isAr ? 'قيد المراجعة' : 'Under Review';
  String get statusCompleted => _isAr ? 'مكتمل' : 'Completed';
  String get timelineReportSubmitted => _isAr ? 'تم تقديم التقرير' : 'Report Submitted';
  String get timelineReportReceived => _isAr ? 'تم استلام تفاصيل التقرير' : 'Report details received';
  String get timelineUnderReview => _isAr ? 'قيد المراجعة' : 'Under Review';
  String get timelineTrafficReviewing => _isAr ? 'السلطة المرورية تراجع الحادث' : 'Traffic authority reviewing';
  String get timelineCaseCompleted => _isAr ? 'تم إغلاق القضية' : 'Case Completed';
  String get timelineFinalReport => _isAr ? 'تم إصدار التقرير النهائي' : 'Final report has been issued';
  String get expectedCompletion => _isAr ? 'الوقت المتوقع للإنجاز: 45 دقيقة' : 'Expected completion: 45 minutes';
  String get downloadReport => _isAr ? 'تحميل التقرير النهائي (PDF)' : 'Download Final Report (PDF)';
  String get pdfComingSoon => _isAr ? 'تحميل PDF قريبًا' : 'PDF download coming soon';

  // ── Profile & Settings ─────────────────────────────────────────────────────
  String get profileSettings => _isAr ? 'الملف الشخصي والإعدادات' : 'Profile & Settings';
  String get personalInformation => _isAr ? 'المعلومات الشخصية' : 'Personal Information';
  String get editLabel => _isAr ? 'تعديل' : 'Edit';
  String get noNameSet => _isAr ? 'لم يُعيَّن اسم' : 'No name set';
  String get myVehicles => _isAr ? 'مركباتي' : 'My Vehicles';
  String get addLabel => _isAr ? 'إضافة' : 'Add';
  String get noVehiclesRegisteredProfile => _isAr ? 'لا توجد مركبات مسجّلة' : 'No vehicles registered';
  String get appPreferences => _isAr ? 'إعدادات التطبيق' : 'App Preferences';
  String get pushNotifications => _isAr ? 'إشعارات الدفع' : 'Push Notifications';
  String get receiveUpdates => _isAr ? 'استقبل تحديثات تقارير الحوادث' : 'Receive accident report updates';
  String get languageLabel => _isAr ? 'اللغة' : 'Language';
  String get security => _isAr ? 'الأمان' : 'SECURITY';
  String get biometricLogin => _isAr ? 'تفعيل تسجيل الدخول البيومتري' : 'Enable Biometric Login';
  String get biometricSubtitle => _isAr
      ? 'استخدم بصمة الإصبع أو التعرف على الوجه لتسجيل دخول أسرع'
      : 'Use fingerprint or face recognition to sign in faster';
  String get account => _isAr ? 'الحساب' : 'Account';
  String get signOut => _isAr ? 'تسجيل الخروج' : 'Sign Out';
  String get removeVehicle => _isAr ? 'إزالة المركبة' : 'Remove Vehicle';
  String get cancel => _isAr ? 'إلغاء' : 'Cancel';
  String get remove => _isAr ? 'إزالة' : 'Remove';
  String get signOutConfirmTitle => _isAr ? 'تسجيل الخروج' : 'Sign Out';
  String get signOutConfirmMsg => _isAr ? 'هل أنت متأكد أنك تريد تسجيل الخروج؟' : 'Are you sure you want to sign out?';
  String get biometricNotAvailable => _isAr
      ? 'المصادقة البيومترية غير متوفرة على هذا الجهاز'
      : 'Biometric authentication not available on this device';
  String get biometricEnabled => _isAr ? 'تم تفعيل تسجيل الدخول البيومتري' : 'Biometric login enabled';
  String get authFailed => _isAr ? 'فشل المصادقة' : 'Authentication failed';
  String removeVehicleConfirm(String manufacturer, String plate) =>
      _isAr ? 'إزالة $manufacturer $plate؟' : 'Remove $manufacturer $plate?';

  // ── Edit Profile ───────────────────────────────────────────────────────────
  String get editProfile => _isAr ? 'تعديل الملف الشخصي' : 'Edit Profile';
  String get saveChanges => _isAr ? 'حفظ التغييرات' : 'Save Changes';
  String get cannotChange => _isAr ? 'لا يمكن التغيير' : 'Cannot change';
  String get profileUpdated => _isAr ? 'تم تحديث الملف الشخصي بنجاح' : 'Profile updated successfully';

  // ── Help ───────────────────────────────────────────────────────────────────
  String get helpGuide => _isAr ? 'المساعدة والإرشاد' : 'Help & Guide';
  String get searchTopics => _isAr ? 'ابحث عن موضوع...' : 'Search topics...';
  String get stepByStepGuide => _isAr ? 'دليل خطوة بخطوة' : 'STEP-BY-STEP GUIDE';
  String get howToReportAccident => _isAr ? 'كيفية الإبلاغ عن حادثك' : 'How to report your accident';
  String get sixStepsDesc => _isAr ? '6 خطوات بسيطة، تستغرق أقل من 5 دقائق' : '6 simple steps, takes under 5 minutes';
  String get startGuide => _isAr ? 'ابدأ الدليل  ←' : 'Start guide  →';
  String get browseTopics => _isAr ? 'تصفح المواضيع' : 'BROWSE TOPICS';
  String noTopicsMatch(String query) =>
      _isAr ? 'لا توجد مواضيع تطابق "$query"' : 'No topics match "$query"';
  String get needImmediateHelp => _isAr ? 'تحتاج إلى مساعدة فورية؟' : 'Need immediate help?';
  String get callEmergencyServices => _isAr ? 'اتصل بخدمات الطوارئ' : 'Call emergency services';
  String get callNow => _isAr ? 'اتصل الآن  >' : 'Call now  >';
  String get faqTitle => _isAr ? 'الأسئلة الشائعة' : 'Frequently asked questions';
  String get faqSubtitle => _isAr ? 'المشكلات الشائعة والإجابات' : 'Common issues & answers';
  String get topicAccidentReporting => _isAr ? 'الإبلاغ عن الحوادث' : 'Accident reporting';
  String get topicAccidentReportingDesc => _isAr ? 'دليل الإبلاغ الكامل' : 'Full reporting guide';
  String get topicPhotosEvidence => _isAr ? 'الصور والأدلة' : 'Photos & evidence';
  String get topicPhotosEvidenceDesc => _isAr ? 'ما الذي يجب التقاطه' : 'What to capture';
  String get topicLocationMaps => _isAr ? 'الموقع والخرائط' : 'Location & maps';
  String get topicLocationMapsDesc => _isAr ? 'GPS والإدخال اليدوي' : 'GPS and manual input';
  String get topicAfterSubmission => _isAr ? 'بعد الإرسال' : 'After submission';
  String get topicAfterSubmissionDesc => _isAr ? 'تتبع تقريرك' : 'Tracking your report';

  // ── FAQ ────────────────────────────────────────────────────────────────────
  String get faqPageTitle => _isAr ? 'الأسئلة الشائعة' : 'Frequently Asked Questions';
  String get filterAll => _isAr ? 'الكل' : 'All';
  String get filterGeneral => _isAr ? 'عام' : 'General';
  String get filterReporting => _isAr ? 'الإبلاغ' : 'Reporting';

  List<Map<String, String>> get generalFaqs => _isAr
      ? [
          {'q': 'ما هو تطبيق جنب؟', 'a': 'جنب يساعدك على الإبلاغ بسرعة عن حوادث السيارات مع الصور والموقع وتفاصيل السائق. تُرسل التقارير مباشرة إلى السلطات المرورية المختصة.'},
          {'q': 'هل بياناتي آمنة؟', 'a': 'جميع البيانات مشفّرة أثناء النقل وفي حالة السكون. تتم مشاركة معلوماتك فقط مع السلطات المرورية المختصة وشركة التأمين.'},
          {'q': 'هل أحتاج إلى اتصال بالإنترنت؟', 'a': 'يتطلب إرسال التقارير وتتبعها اتصالًا نشطًا بالإنترنت. يمكنك إعداد التقرير دون اتصال، لكن الإرسال يتطلب الاتصال.'},
          {'q': 'ما أنواع الحوادث التي يمكنني الإبلاغ عنها؟', 'a': 'يدعم جنب حوادث المركبات البسيطة والمتوسطة. في حالة الحوادث الخطيرة مع إصابات، اتصل دائمًا بخدمات الطوارئ أولًا.'},
        ]
      : [
          {'q': 'What is Janneb?', 'a': 'Janneb helps you quickly file accident reports with photos, location, and driver details. Reports are sent directly to relevant traffic authorities.'},
          {'q': 'Is my data secure?', 'a': 'All data is encrypted in transit and at rest. Your information is only shared with relevant traffic authorities and your insurance provider.'},
          {'q': 'Do I need an internet connection?', 'a': 'An active internet connection is required to submit reports and track their status. You can draft a report offline, but submission requires connectivity.'},
          {'q': 'Which types of accidents can I report?', 'a': 'Janneb supports minor and moderate vehicle accidents. For serious accidents with injuries, always call emergency services first.'},
        ];

  List<Map<String, String>> get reportingFaqs => _isAr
      ? [
          {'q': 'كم عدد الصور التي يجب التقاطها؟', 'a': 'التقط 4 صور على الأقل لكل مركبة — من الأمام والخلف والجانبين. التقط أيضًا لوحات الترخيص والأضرار الواضحة عن قرب ومشهد الطريق المحيط.'},
          {'q': 'ماذا لو لم أتمكن من تأكيد موقعي؟', 'a': 'يمكنك تحريك الدبوس يدويًا على الخريطة أو كتابة وصف الموقع في حقل التفاصيل. تأكد من تفعيل GPS للحصول على أفضل دقة.'},
          {'q': 'هل يمكنني تعديل تقرير بعد إرساله؟', 'a': 'لا يمكن تعديل التقارير بعد إرسالها. إذا كنت بحاجة إلى تصحيحات، تواصل مع الدعم عبر التطبيق أو اتصل بخط المساعدة.'},
          {'q': 'كم يستغرق مراجعة التقرير؟', 'a': 'تتم مراجعة معظم التقارير في غضون 45 دقيقة خلال ساعات العمل. ستتلقى إشعارًا عند تغيير الحالة.'},
        ]
      : [
          {'q': 'How many photos should I take?', 'a': 'Take at least 4 photos per vehicle — front, rear, and both sides. Also capture license plates, visible damage close-up, and the surrounding road scene.'},
          {'q': "What if I can't confirm my location?", 'a': 'You can manually adjust the map pin or type a location description in the details field. Make sure GPS is enabled for best accuracy.'},
          {'q': 'Can I edit a report after submitting?', 'a': 'Reports cannot be edited after submission. If corrections are needed, contact support through the app or call the helpline.'},
          {'q': 'How long does report review take?', 'a': 'Most reports are reviewed within 45 minutes during business hours. You will receive a notification when the status changes.'},
        ];

  // ── Reporting Guide ────────────────────────────────────────────────────────
  String get reportingGuideTitle => _isAr ? 'دليل الإبلاغ' : 'Reporting guide';
  String get sixSteps => _isAr ? '6 خطوات' : '6 steps';
  String get followSteps => _isAr ? 'اتبع هذه الخطوات بعد حادث ' : 'Follow these steps after a ';
  String get minorAccident => _isAr ? 'بسيط' : 'minor accident';
  String get startReportingNow => _isAr ? 'ابدأ الإبلاغ الآن' : 'Start reporting now';
  String get stepTitle1 => _isAr ? 'تأكد من السلامة أولًا' : 'Ensure safety first';
  String get stepDesc1 => _isAr ? 'انتقل إلى وضع آمن، شغّل أضواء الخطر' : 'Move to a safe position, turn on hazard lights';
  String get stepTitle2 => _isAr ? 'وثّق الحادث' : 'Document the accident';
  String get stepDesc2 => _isAr ? 'التقط صورًا واضحة للمركبتين والأضرار' : 'Take clear photos of both vehicles and damage';
  String get stepTitle3 => _isAr ? 'أكّد موقعك' : 'Confirm your location';
  String get stepDesc3 => _isAr ? 'تحقق من دقة GPS أو اضبط الموقع يدويًا' : 'Verify GPS accuracy or adjust pin manually';
  String get stepTitle4 => _isAr ? 'أدخل تفاصيل المركبة' : 'Enter vehicle details';
  String get stepDesc4 => _isAr ? 'أضف رقم اللوحة والتأمين والوصف' : 'Add plate number, insurance, and description';
  String get stepTitle5 => _isAr ? 'راجع تقريرك' : 'Review your report';
  String get stepDesc5 => _isAr ? 'تحقق من جميع المعلومات قبل الإرسال' : 'Check all information before submitting';
  String get stepTitle6 => _isAr ? 'أرسل التقرير وحرّك المركبة' : 'Submit and move vehicle';
  String get stepDesc6 => _isAr ? 'أرسل التقرير، ثم انتقل بأمان إلى جانب الطريق' : 'Submit report, then move safely to roadside';

  // ── Notifications ─────────────────────────────────────────────────────────
  String get notifications => _isAr ? 'الإشعارات' : 'Notifications';
  String get markAllAsRead => _isAr ? 'تحديد الكل كمقروء' : 'Mark all as read';
  String get noNotifications => _isAr ? 'لا توجد إشعارات' : 'No notifications';
  String minutesAgo(int n) => _isAr ? 'منذ $n دقيقة' : '$n minutes ago';
  String hoursAgo(int n) => _isAr ? 'منذ $n ساعة' : '$n hours ago';
  String daysAgo(int n) => _isAr ? 'منذ $n يوم' : '$n days ago';

  // ── Report Card / Summary Card ─────────────────────────────────────────────
  String get dateLabel => _isAr ? 'التاريخ' : 'Date';
  String get statusLabel => _isAr ? 'الحالة' : 'Status';
  // ── Insurance ──────────────────────────────────────────────────────────────
  String get insuranceTitle => _isAr ? 'التأمين' : 'Insurance';
  String get insuranceSubtitle => _isAr ? 'مركباتك المسجّلة وشركات التأمين' : 'Your registered vehicles and insurance providers';
  String get callInsurance => _isAr ? 'اتصل بالتأمين' : 'Call Insurance';
  String get noInsuranceOnFile => _isAr ? 'لا يوجد تأمين مسجّل' : 'No insurance on file';
  String get failedToLoadInsurance => _isAr ? 'فشل تحميل بيانات التأمين' : 'Failed to load insurance data';
  String get noVehiclesInsurance => _isAr ? 'لا توجد مركبات مسجّلة' : 'No vehicles registered';
  String get addVehicleForInsurance => _isAr ? 'أضف مركبة لعرض معلومات التأمين.' : 'Add a vehicle to view its insurance information.';
  String get addVehicleBtn => _isAr ? 'إضافة مركبة' : 'Add Vehicle';
  String callingInsurance(String company) =>
      _isAr ? 'جارٍ الاتصال بـ$company...' : 'Calling $company insurance...';
}
