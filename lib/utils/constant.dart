import 'package:nb_utils/nb_utils.dart';

/// DO NOT CHANGE THIS PACKAGE NAME
const APP_PACKAGE_NAME = 'com.iqonic.handyman.admin';

const BOOKING_TYPE_ALL = 'All';
const BOOKING_TYPE_USER_POST_JOB = 'user_post_job';
const BOOKING_TYPE_SERVICE = 'service';

//region Configs
const DECIMAL_POINT = 2;
const PER_PAGE_ITEM = 25;
const PER_PAGE_ALL = 'all';
const PLAN_REMAINING_DAYS = 15;
const LABEL_TEXT_SIZE = 14;
const PERMISSION_STATUS = 'permissionStatus';
const APP_BAR_TEXT_SIZE = 18;
const CARD_SECONDARY_TEXT_STYLE_SIZE = 12;
const CARD_BOLD_TEXT_STYLE_SIZE = 12;
const CARD_IMAGE_SIZE = 14;
const CARD_DIVIDER_HEIGHT = 16.0;

enum GalleryFileTypes { CANCEL, CAMERA, GALLERY }

const CATEGORY_TYPE_ALL = 'all';
const CATEGORY_BASED_SELECT_PACKAGE_SERVICE = 'CATEGORY_BASED_SELECT_PACKAGE_SERVICE';

//endregion

//region default handyman login
const DEMO_ADMIN_EMAIL = 'demo@admin.com';
const DEMO_PASS = '12345678';
//endregion

//region Commission Types
const COMMISSION_TYPE_PERCENT = 'percent';
const COMMISSION_TYPE_FIXED = 'fixed';
//endregion

//region LiveStream Keys
const LIVESTREAM_TOKEN = 'tokenStream';
const LIVESTREAM_UPDATE_BOOKINGS = 'LiveStreamUpdateBookings';
const LIVESTREAM_HANDY_BOARD = 'HandyBoardStream';
const LIVESTREAM_HANDYMAN_ALL_BOOKING = "handymanAllBooking";
const LIVESTREAM_PROVIDER_ALL_BOOKING = "providerAllBooking";
const LIVESTREAM_UPDATE_BOOKING_LIST = "UpdateBookingList";
const LIVESTREAM_UPDATE_SERVICE_LIST = "LIVESTREAM_UPDATE_SERVICE_LIST";
const LIVESTREAM_UPDATE_DASHBOARD = "streamUpdateDashboard";
const LIVESTREAM_START_TIMER = "startTimer";
const LIVESTREAM_PAUSE_TIMER = "pauseTimer";
//endregion

//region Theme Mode Type
const THEME_MODE_LIGHT = 0;
const THEME_MODE_DARK = 1;
const THEME_MODE_SYSTEM = 2;
//endregion

//region SharedPreferences Keys
const IS_FIRST_TIME = 'IsFirstTime';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const IS_TESTER = 'IS_TESTER';
const USER_ID = 'USER_ID';
const USER_TYPE = 'USER_TYPE';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_PASSWORD = 'USER_PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const IS_REMEMBERED = "IS_REMEMBERED";
const TOKEN = 'TOKEN';
const USERNAME = 'USERNAME';
const DISPLAY_NAME = 'DISPLAY_NAME';
const STATUS = 'STATUS';
const UID = 'UID';
const PROVIDER_ID = 'PROVIDER_ID';
const PASSWORD = 'PASSWORD';
const CONTACT_NUMBER = 'CONTACT_NUMBER';
const ADDRESS = 'ADDRESS';
const COUNTRY_ID = 'COUNTRY_ID';
const STATE_ID = 'STATE_ID';
const CITY_ID = 'CITY_ID';
const DESIGNATION = 'DESIGNATION';
const SERVICE_ADDRESS_ID = 'SERVICE_ADDRESS_ID';
const CREATED_AT = 'CREATED_AT';
const EARNING_TYPE = 'EARNING_TYPE';
const PRIVACY_POLICY = 'PRIVACY_POLICY';
const TERMS_AND_CONDITION = 'TERMS_AND_CONDITION';
const SERVICE_TYPE_INACTIVE = 'Inactive';
const SERVICE_TYPE_ACTIVE = 'Active';
const INQUIRY_EMAIL = 'INQUIRY_EMAIL';
const HELPLINE_NUMBER = 'HELPLINE_NUMBER';
const IS_ADVANCE_PAYMENT_ALLOWED = 'IS_ADVANCE_PAYMENT_ALLOWED';
const IS_DIGITAL_SERVICE_ALLOWED = 'IS_DIGITAL_SERVICE_ALLOWED';

const ADD_BOOKING = 'add_booking';
const ASSIGNED_BOOKING = 'assigned_booking';
const TRANSFER_BOOKING = 'transfer_booking';
const UPDATE_BOOKING_STATUS = 'update_booking_status';
const CANCEL_BOOKING = 'cancel_booking';
const PAYMENT_MESSAGE_STATUS = 'payment_message_status';
//endregion

//region  Login Type
const USER_TYPE_PROVIDER = 'provider';
const USER_TYPE_HANDYMAN = 'handyman';
const USER_TYPE_USER = 'user';
const USER_TYPE_ADMIN = 'admin';
const DEMO_ADMIN = 'demo_admin';
const ADMIN_DEMO = "Demo Admin";
const RESET = 'Reset';
const USER_STATUS_ACTIVE = "1";
//endregion

// region Package Type
const PACKAGE_TYPE_SINGLE = 'single';
const PACKAGE_TYPE_MULTIPLE = 'multiple';
//endregion

//region  Earning Type
const EARNING_TYPE_COMMISSION = 'commission';
const EARNING_TYPE_SUBSCRIPTION = 'subscription';
//endregion

//region CONFIGURATION KEYS
const CONFIGURATION_TYPE_CURRENCY = 'CURRENCY';
const CONFIGURATION_TYPE_CURRENCY_POSITION = 'CURRENCY_POSITION';
const CURRENCY_COUNTRY_CODE = 'CURRENCY_COUNTRY_CODE';
const CURRENCY_COUNTRY_ID = 'CURRENCY_COUNTRY_ID';
const IS_CURRENT_LOCATION = 'CURRENT_LOCATION';
const CURRENCY_COUNTRY_SYMBOL = 'CURRENCY_COUNTRY_SYMBOL';
const CONFIGURATION_KEY_CURRENCY_COUNTRY_ID = 'CURRENCY_COUNTRY_ID';
//endregion

//region CURRENCY POSITION
const CURRENCY_POSITION_LEFT = 'left';
const CURRENCY_POSITION_RIGHT = 'right';
//endregion

//region Extra
const ACTIVE = 'active';
const IN_ACTIVE = 'inactive';
const CASH = 'cash';
const BANK = 'bank';
const WALLET = 'wallet';

const NOTIFICATION_TYPE_ALL = 'alldata';
const NOTIFICATION_TYPE_SERVICES = 'services';

const FIXED = 'fixed';
const PERCENTAGE = 'percentage';
const PERCENT = 'percent';
const REQUIRED = 'Required';
const NOT_REQUIRED = 'Not-required';

const LATITUDE = 'LATITUDE';
const LONGITUDE = 'LONGITUDE';
const CURRENT_ADDRESS = 'CURRENT_ADDRESS';

const USER_SERVICE_RATING = 'user_service_rating';
const HANDYMAN_RATING = 'handyman_rating';
//endregion

//region ProviderType
const PROVIDER_TYPE_FREELANCE = 'freelance';
const PROVIDER_TYPE_COMPANY = 'company';
//endregion

// region JOB REQUEST STATUS
const JOB_REQUEST_STATUS_REQUESTED = "requested";
const JOB_REQUEST_STATUS_ACCEPTED = "accepted";
const JOB_REQUEST_STATUS_ASSIGNED = "assigned";
// endregion

//region Notification Mark as Read
const MARK_AS_READ = 'markas_read';
//endregion

//region SERVICE TYPE
const SERVICE_TYPE_HOURLY = 'hourly';
const SERVICE_TYPE_FIXED = 'fixed';
const SERVICE_TYPE_FREE = 'free';
//endregion

//region BOOKING STATUS
const BOOKING_PAYMENT_STATUS_ALL = 'all';
const BOOKING_STATUS_PENDING = 'pending';
const BOOKING_STATUS_ACCEPT = 'accept';
const BOOKING_STATUS_ON_GOING = 'on_going';
const BOOKING_STATUS_IN_PROGRESS = 'in_progress';
const BOOKING_STATUS_HOLD = 'hold';
const BOOKING_STATUS_CANCELLED = 'cancelled';
const BOOKING_STATUS_REJECTED = 'rejected';
const BOOKING_STATUS_FAILED = 'failed';
const BOOKING_STATUS_COMPLETED = 'completed';
const BOOKING_STATUS_PENDING_APPROVAL = 'pending_approval';
const BOOKING_STATUS_WAITING_ADVANCED_PAYMENT = 'waiting';
const BOOKING_STATUS_PAID = 'paid';
const PAYMENT_STATUS_ADVANCE = 'advanced_paid';
//endregion

//region PAYMENT METHOD
const PAYMENT_METHOD_COD = 'cash';
const PAYMENT_METHOD_STRIPE = 'stripe';
const PAYMENT_METHOD_RAZOR = 'razorPay';
const PAYMENT_METHOD_FLUTTER_WAVE = 'flutterwave';
//endregion

//region Errors
const USER_NOT_CREATED = "User not created";
const USER_CANNOT_LOGIN = "User can't login";
const USER_NOT_FOUND = "User not found";
//endregion

//region service payment status
const PAID = 'paid';
const PENDING = 'pending';
//endregion

//region ProviderStore
const RESTORE = "restore";
const FORCE_DELETE = "forcedelete";
const type = "type";
//endregion

//region Mail And Tel URL
const MAIL_TO = 'mailto:';
const TEL = 'tel:';
//endregion

//region FireBase Collection Name
const MESSAGES_COLLECTION = "messages";
const USER_COLLECTION = "users";
const CONTACT_COLLECTION = "contact";
const CHAT_DATA_IMAGES = "chatImages";

const IS_ENTER_KEY = "IS_ENTER_KEY";
const SELECTED_WALLPAPER = "SELECTED_WALLPAPER";
const SELECT_SUBCATEGORY = "SELECT_SUBCATEGORY";
const PER_PAGE_CHAT_COUNT = 50;
const PER_PAGE_CHAT_LIST_COUNT = 10;

const TEXT = "TEXT";
const IMAGE = "IMAGE";

const VIDEO = "VIDEO";
const AUDIO = "AUDIO";
//endregion

//region RTLLanguage
const List<String> RTL_LANGUAGES = ['ar', 'ur'];
//endregion

//region SERVICE PAYMENT STATUS
const SERVICE_PAYMENT_STATUS_PAID = 'paid';
const SERVICE_PAYMENT_STATUS_PENDING = 'pending';
const SERVICE_PAYMENT_STATUS_PENDING_BY_ADMIN = 'pending_by_admin';
//endregion

//region DateFormat
const DATE_FORMAT_1 = 'M/d/yyyy hh:mm a';
const DATE_FORMAT_2 = 'd MMM, yyyy';
const DATE_FORMAT_3 = 'hh:mm a';
const HOUR_12_FORMAT = 'hh:mm a';
const DATE_FORMAT_4 = 'dd MMM';
const DATE_FORMAT_5 = 'yyyy';
const DATE_FORMAT_6 = 'd MMMM, yyyy';
const DATE_FORMAT_7 = 'yyyy-MM-dd';
const DATE_FORMAT_8 = 'd MMM, yyyy hh:mm a';

//endregion

//region SUBSCRIPTION PAYMENT STATUS
const SUBSCRIPTION_STATUS_ACTIVE = 'active';
const SUBSCRIPTION_STATUS_INACTIVE = 'inactive';
//endregion

//region Visit Type
const VISIT_OPTION_ON_SITE = 'on_site';
const VISIT_OPTION_ONLINE = 'online';
// endregion

const GOOGLE_MAP_PREFIX = 'https://www.google.com/maps/search/?api=1&query=';
SlideConfiguration sliderConfigurationGlobal = SlideConfiguration(duration: 400.milliseconds, delay: 50.milliseconds);
const USE_MATERIAL_YOU_THEME = 'USE_MATERIAL_YOU_THEME';
