import 'package:flutter/material.dart';

// ==============================
// IMPROVED LOCALIZATION MANAGER
// ==============================

class QNowLocalizations {
  // Singleton instance
  static final QNowLocalizations _instance = QNowLocalizations._internal();
  factory QNowLocalizations() => _instance;
  QNowLocalizations._internal();

  // Current locale
  Locale _currentLocale = const Locale('en');
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];

  // Localized values
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App & General
      'app_title': 'QNow',
      'welcome': 'Welcome',
      'loading': 'Loading...',
      'empty': 'No items found',
      'error': 'Error',
      'success': 'Success',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'add': 'Add',
      'edit': 'Edit',
      'join': 'Join',
      'leave': 'Leave',
      'serve': 'Serve',
      'notify': 'Notify',
      'notified': 'Notified',
      'served': 'Served',
      'try_again': 'Try Again',
      'retry': 'Retry',
      'close': 'Close',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'done': 'Done',
      'next': 'Next',
      'previous': 'Previous',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'refresh': 'Refresh',
      'language': 'Language',
      'get_started': 'Get Started',
      
      // Authentication & Roles
      'login': 'Login',
      'signup': 'Sign Up',
      'sign_out': 'Sign Out',
      'business_owner': 'Business Owner',
      'customer': 'Customer',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': 'Don\'t have an account?',
      'already_have_account': 'Already have an account?',
      'create_account': 'Create Account',
      'reset_password': 'Reset Password',
      
      // User Info
      'name': 'Name',
      'full_name': 'Full Name',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'phone': 'Phone',
      'phone_number': 'Phone Number',
      'profile': 'Profile',
      'change_pass': 'Change Password',
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'confirm_new_password': 'Confirm New Password',
      'update_profile': 'Update Profile',
      'personal_info': 'Personal Information',
      
      // Queue Management
      'add_queue': 'Add Queue',
      'create_queue': 'Create Queue',
      'your_queues': 'Your Queues',
      'my_queues': 'My Queues',
      'joined_queues': 'Joined Queues',
      'available_queues': 'Available Queues',
      'no_queues': 'No queues yet',
      'queue_name': 'Queue Name',
      'business_name': 'Business Name',
      'waiting_list': 'Waiting List',
      'add_person': 'Add Person',
      'add_customer': 'Add Customer',
      'position_in_queue': 'Position: #',
      'estimated_time': 'Est. Time: ',
      'minutes': ' min',
      'people_waiting': ' waiting',
      'people_ahead': ' people ahead',
      'total_queues': 'Total Queues',
      'active_now': 'Active Now',
      'max_capacity': 'Max Capacity',
      'current_size': 'Current Size',
      'wait_time': 'Wait Time',
      'average_wait': 'Average Wait',
      'queue_status': 'Queue Status',
      'queue_active': 'Active',
      'queue_inactive': 'Inactive',
      'queue_paused': 'Paused',
      'queue_full': 'Full',
      'join_queue': 'Join Queue',
      'leave_queue': 'Leave Queue',
      'join_queue_confirm': 'Are you sure you want to join this queue?',
      'join_queue_description': 'Browse available queues and join the ones you need.',
      'queue_tips': 'Tip: Arrive on time and keep your phone handy for notifications.',
      'refreshed': 'Refreshed',
      'leave_queue_confirm': 'Are you sure you want to leave this queue?',
      'position': 'Position',
      'not_joined': 'Not joined',
      'view_details': 'View Details',
      'no_results': 'No results found',
      'no_available_queues': 'No available queues at the moment',
      'try_different_search': 'Try a different search term',
      'check_back_later': 'Please check back later',
      'add_queue_hint': 'Create your first queue to start serving customers',
      'delete_queue_confirm': 'Are you sure you want to delete this queue?',
      'serve_confirm': 'Serve',
      'notify_confirm': 'Notify',
      'remove_confirm': 'Remove',
      'served_at': 'Served at',
      'notified_at': 'Notified at',
      'spots_available': 'spots available',
      'customers': 'customers',
      'no_customers': 'No customers in the queue',
      'add_customer_hint': 'Add customers manually from here',
      'capacity': 'Capacity',
      'avg_time': 'Avg. Time',
      'max_queues_reached': 'You can join up to 3 queues only',
      'queue_details': 'Queue Details',
      'queue_settings': 'Queue Settings',
      'manage_queue': 'Manage Queue',
      'manage_your_queues': 'Manage Your Queues',
      
      // Search & Discovery
      'search_hint': 'Search for business...',
      'search_queues': 'Search queues...',
      'search_businesses': 'Search businesses...',
      'nearby_businesses': 'Nearby Businesses',
      'popular_queues': 'Popular Queues',
      'recommended': 'Recommended',
      'recent': 'Recent',
      
      // Notifications & Status
      'queue_created': 'Queue created successfully',
      'queue_deleted': 'Queue deleted successfully',
      'queue_updated': 'Queue updated successfully',
      'person_added': 'Person added to queue',
      'person_removed': 'Person removed from queue',
      'joined_queue': 'You joined the queue',
      'left_queue': 'You left the queue',
      'queue_full_error': 'Queue is full',
      'position_updated': 'Position updated',
      'turn_soon': 'Your turn is coming soon',
      'your_turn': 'It\'s your turn!',
      'missed_turn': 'You missed your turn',
      'notification': 'Notification',
      'notifications': 'Notifications',
      
      // Settings & Help
      'settings': 'Settings',
      'help': 'Help & Support',
      'about': 'About Us',
      'contact_support': 'Contact Support',
      'email_support': 'Email Support',
      'call_support': 'Call Support',
      'dev_team': 'Development Team',
      'about_project': 'About The Project',
      'version': 'Version 1.0.0',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',
      'faq': 'FAQ',
      'support': 'Support',
      'feedback': 'Feedback',
      'rate_app': 'Rate App',
      'share_app': 'Share App',
      
      // Business Specific
      'business_info': 'Business Information',
      'business_type': 'Business Type',
      'address': 'Address',
      'location': 'Location',
      'business_hours': 'Business Hours',
      'manage_queues': 'Manage Queues',
      'customer_management': 'Customer Management',
      'business_settings': 'Business Settings',
      'business_profile': 'Business Profile',
      
      // Time & Status
      'active': 'Active',
      'inactive': 'Inactive',
      'paused': 'Paused',
      'closed': 'Closed',
      'today': 'Today',
      'tomorrow': 'Tomorrow',
      'yesterday': 'Yesterday',
      'now': 'Now',
      'soon': 'Soon',
      'later': 'Later',
      'status': 'Status',
      'waiting': 'Waiting',
      'cancelled': 'Cancelled',
      'missed': 'Missed',
      'total_customers': 'Total Customers',
      
      // Validation Messages
      'required_field': 'This field is required',
      'invalid_email': 'Invalid email address',
      'invalid_phone': 'Invalid phone number',
      'phone_too_short': 'Phone number too short',
      'password_too_short': 'Password must be at least 6 characters',
      'passwords_not_match': 'Passwords do not match',
      'invalid_name': 'Name must be at least 3 characters',
      
      // Actions
      'view': 'View',
      'remove': 'Remove',
      'clear': 'Clear',
      'select': 'Select',
      'choose': 'Choose',
      'browse': 'Browse',
      'upload': 'Upload',
      'download': 'Download',
      'share': 'Share',
      'copy': 'Copy',
      'paste': 'Paste',
    },
    'fr': {
      // App & General
      'app_title': 'QNow',
      'welcome': 'Bienvenue',
      'loading': 'Chargement...',
      'empty': 'Aucun élément trouvé',
      'error': 'Erreur',
      'success': 'Succès',
      'cancel': 'Annuler',
      'save': 'Enregistrer',
      'delete': 'Supprimer',
      'add': 'Ajouter',
      'edit': 'Modifier',
      'join': 'Rejoindre',
      'leave': 'Quitter',
      'serve': 'Servir',
      'notify': 'Notifier',
      'notified': 'Notifié',
      'served': 'Servi',
      'try_again': 'Réessayer',
      'retry': 'Réessayer',
      'close': 'Fermer',
      'confirm': 'Confirmer',
      'yes': 'Oui',
      'no': 'Non',
      'ok': 'OK',
      'done': 'Terminé',
      'next': 'Suivant',
      'previous': 'Précédent',
      'search': 'Rechercher',
      'filter': 'Filtrer',
      'sort': 'Trier',
      'refresh': 'Actualiser',
      'language': 'Langue',
      'get_started': 'Commencer',
      
      // Authentication & Roles
      'login': 'Connexion',
      'signup': 'S\'inscrire',
      'sign_out': 'Déconnexion',
      'business_owner': 'Propriétaire d\'entreprise',
      'customer': 'Client',
      'email': 'E-mail',
      'password': 'Mot de passe',
      'confirm_password': 'Confirmer le mot de passe',
      'forgot_password': 'Mot de passe oublié ?',
      'dont_have_account': 'Vous n\'avez pas de compte ?',
      'already_have_account': 'Vous avez déjà un compte ?',
      'create_account': 'Créer un compte',
      'reset_password': 'Réinitialiser le mot de passe',
      
      // User Info
      'name': 'Nom',
      'full_name': 'Nom complet',
      'first_name': 'Prénom',
      'last_name': 'Nom',
      'phone': 'Téléphone',
      'phone_number': 'Numéro de téléphone',
      'profile': 'Profil',
      'change_pass': 'Changer le mot de passe',
      'current_password': 'Mot de passe actuel',
      'new_password': 'Nouveau mot de passe',
      'confirm_new_password': 'Confirmer le nouveau mot de passe',
      'update_profile': 'Mettre à jour le profil',
      'personal_info': 'Informations personnelles',
      
      // Queue Management
      'add_queue': 'Ajouter une file',
      'create_queue': 'Créer une file',
      'your_queues': 'Vos files',
      'my_queues': 'Mes files',
      'joined_queues': 'Files rejointes',
      'available_queues': 'Files disponibles',
      'no_queues': 'Aucune file',
      'queue_name': 'Nom de la file',
      'business_name': 'Nom de l\'entreprise',
      'waiting_list': 'Liste d\'attente',
      'add_person': 'Ajouter une personne',
      'add_customer': 'Ajouter un client',
      'position_in_queue': 'Position: #',
      'estimated_time': 'Temps estimé: ',
      'minutes': ' min',
      'people_waiting': ' en attente',
      'people_ahead': ' personnes devant',
      'total_queues': 'Total Files',
      'active_now': 'Actif maintenant',
      'max_capacity': 'Capacité max',
      'current_size': 'Taille actuelle',
      'wait_time': 'Temps d\'attente',
      'average_wait': 'Temps d\'attente moyen',
      'queue_status': 'Statut de la file',
      'queue_active': 'Actif',
      'queue_inactive': 'Inactif',
      'queue_paused': 'En pause',
      'queue_full': 'Complet',
      'join_queue': 'Rejoindre la file',
      'leave_queue': 'Quitter la file',
      'queue_details': 'Détails de la file',
      'queue_settings': 'Paramètres de file',
      'join_queue_confirm': 'Êtes-vous sûr de vouloir rejoindre cette file ?',
      'join_queue_description': 'Parcourez les files disponibles et rejoignez celles dont vous avez besoin.',
      'queue_tips': 'Conseil : Arrivez à l’heure et gardez votre téléphone à portée de main pour les notifications.',
      'refreshed': 'Actualisé',
      'leave_queue_confirm': 'Êtes-vous sûr de vouloir quitter cette file ?',
      'position': 'Position',
      'not_joined': 'Non rejoint',
      'view_details': 'Voir les détails',
      'no_results': 'Aucun résultat trouvé',
      'no_available_queues': 'Aucune file disponible pour le moment',
      'try_different_search': 'Essayez un terme de recherche différent',
      'check_back_later': 'Veuillez revenir plus tard',
      'add_queue_hint': 'Créez votre première file pour commencer à servir des clients',
      'delete_queue_confirm': 'Êtes-vous sûr de vouloir supprimer cette file ?',
      'serve_confirm': 'Servir',
      'notify_confirm': 'Notifier',
      'remove_confirm': 'Supprimer',
      'served_at': 'Servi à',
      'notified_at': 'Notifié à',
      'spots_available': 'places disponibles',
      'customers': 'clients',
      'no_customers': 'Aucun client dans la file',
      'add_customer_hint': 'Ajoutez des clients manuellement ici',
      'capacity': 'Capacité',
      'avg_time': 'Temps moyen',
      'max_queues_reached': 'Vous pouvez rejoindre au maximum 3 files',
      'manage_queue': 'Gérer la file',
      'manage_your_queues': 'Gérer vos files',
      'total_customers': 'Total Clients',
      
      // Search & Discovery
      'search_hint': 'Rechercher une entreprise...',
      'search_queues': 'Rechercher des files...',
      'search_businesses': 'Rechercher des entreprises...',
      'nearby_businesses': 'Entreprises à proximité',
      'popular_queues': 'Files populaires',
      'recommended': 'Recommandé',
      'recent': 'Récent',
      
      // Notifications & Status
      'queue_created': 'File créée avec succès',
      'queue_deleted': 'File supprimée avec succès',
      'queue_updated': 'File mise à jour avec succès',
      'person_added': 'Personne ajoutée à la file',
      'person_removed': 'Personne supprimée de la file',
      'joined_queue': 'Vous avez rejoint la file',
      'left_queue': 'Vous avez quitté la file',
      'queue_full_error': 'La file est pleine',
      'position_updated': 'Position mise à jour',
      'turn_soon': 'Votre tour approche',
      'your_turn': 'C\'est votre tour!',
      'missed_turn': 'Vous avez manqué votre tour',
      'notification': 'Notification',
      'notifications': 'Notifications',
      
      // Settings & Help
      'settings': 'Paramètres',
      'help': 'Aide & Support',
      'about': 'À propos',
      'contact_support': 'Contacter le support',
      'email_support': 'Email Support',
      'call_support': 'Appeler le support',
      'dev_team': 'Équipe de développement',
      'about_project': 'À propos du projet',
      'version': 'Version 1.0.0',
      'privacy_policy': 'Politique de confidentialité',
      'terms_of_service': 'Conditions d\'utilisation',
      'faq': 'FAQ',
      'support': 'Support',
      'feedback': 'Retour',
      'rate_app': 'Noter l\'app',
      'share_app': 'Partager l\'app',
      
      // Business Specific
      'business_info': 'Informations de l\'entreprise',
      'business_type': 'Type d\'entreprise',
      'address': 'Adresse',
      'location': 'Localisation',
      'business_hours': 'Heures d\'ouverture',
      'manage_queues': 'Gérer les files',
      'customer_management': 'Gestion des clients',
      'business_settings': 'Paramètres de l\'entreprise',
      'business_profile': 'Profil de l\'entreprise',
      
      // Time & Status
      'active': 'Actif',
      'inactive': 'Inactif',
      'paused': 'En pause',
      'closed': 'Fermé',
      'today': 'Aujourd\'hui',
      'tomorrow': 'Demain',
      'yesterday': 'Hier',
      'now': 'Maintenant',
      'soon': 'Bientôt',
      'later': 'Plus tard',
      'status': 'Statut',
      'waiting': 'En attente',
      'cancelled': 'Annulé',
      'missed': 'Manqué',
      
      // Validation Messages
      'required_field': 'Ce champ est obligatoire',
      'invalid_email': 'Adresse e-mail invalide',
      'invalid_phone': 'Numéro de téléphone invalide',
      'phone_too_short': 'Numéro de téléphone trop court',
      'password_too_short': 'Le mot de passe doit contenir au moins 6 caractères',
      'passwords_not_match': 'Les mots de passe ne correspondent pas',
      'invalid_name': 'Le nom doit contenir au moins 3 caractères',
      
      // Actions
      'view': 'Voir',
      'remove': 'Supprimer',
      'clear': 'Effacer',
      'select': 'Sélectionner',
      'choose': 'Choisir',
      'browse': 'Parcourir',
      'upload': 'Télécharger',
      'download': 'Télécharger',
      'share': 'Partager',
      'copy': 'Copier',
      'paste': 'Coller',
    },
    'ar': {
      // App & General
      'app_title': 'كيو ناو',
      'welcome': 'مرحباً',
      'loading': 'جاري التحميل...',
      'empty': 'لم يتم العثور على عناصر',
      'error': 'خطأ',
      'success': 'نجاح',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'add': 'إضافة',
      'edit': 'تعديل',
      'join': 'انضم',
      'leave': 'غادر',
      'serve': 'خدمة',
      'notify': 'تنبيه',
      'notified': 'تم التنبيه',
      'served': 'تمت الخدمة',
      'try_again': 'حاول مرة أخرى',
      'retry': 'إعادة المحاولة',
      'close': 'إغلاق',
      'confirm': 'تأكيد',
      'yes': 'نعم',
      'no': 'لا',
      'ok': 'موافق',
      'done': 'تم',
      'next': 'التالي',
      'previous': 'السابق',
      'search': 'بحث',
      'filter': 'تصفية',
      'sort': 'ترتيب',
      'refresh': 'تحديث',
      'language': 'اللغة',
      'get_started': 'البدء',
      
      // Authentication & Roles
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'sign_out': 'تسجيل الخروج',
      'customer': 'عميل',
      'business_owner': 'صاحب عمل',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'dont_have_account': 'ليس لديك حساب؟',
      'already_have_account': 'لديك حساب بالفعل؟',
      'create_account': 'إنشاء حساب',
      'reset_password': 'إعادة تعيين كلمة المرور',
      
      // User Info
      'name': 'الاسم',
      'full_name': 'الاسم الكامل',
      'first_name': 'الاسم الأول',
      'last_name': 'اسم العائلة',
      'phone': 'الهاتف',
      'phone_number': 'رقم الهاتف',
      'profile': 'الملف الشخصي',
      'change_pass': 'تغيير كلمة المرور',
      'current_password': 'كلمة المرور الحالية',
      'new_password': 'كلمة المرور الجديدة',
      'confirm_new_password': 'تأكيد كلمة المرور الجديدة',
      'update_profile': 'تحديث الملف الشخصي',
      'personal_info': 'المعلومات الشخصية',
      
      // Queue Management
      'add_queue': 'إضافة طابور',
      'create_queue': 'إنشاء طابور',
      'your_queues': 'طوابيرك',
      'my_queues': 'طوابيري',
      'joined_queues': 'الطوابير المنضم إليها',
      'available_queues': 'الطوابير المتاحة',
      'no_queues': 'لا توجد طوابير',
      'queue_name': 'اسم الطابور',
      'business_name': 'اسم العمل',
      'waiting_list': 'قائمة الانتظار',
      'add_person': 'إضافة شخص',
      'add_customer': 'إضافة عميل',
      'position_in_queue': 'الموضع: #',
      'estimated_time': 'الوقت المتوقع: ',
      'minutes': ' دقيقة',
      'people_waiting': ' في الانتظار',
      'people_ahead': ' أشخاص أمامك',
      'total_queues': 'إجمالي الطوابير',
      'active_now': 'نشطة الآن',
      'max_capacity': 'السعة القصوى',
      'current_size': 'الحجم الحالي',
      'wait_time': 'وقت الانتظار',
      'average_wait': 'متوسط وقت الانتظار',
      'queue_status': 'حالة الطابور',
      'queue_active': 'نشط',
      'queue_inactive': 'غير نشط',
      'queue_paused': 'متوقف',
      'queue_full': 'ممتلئ',
      'join_queue': 'انضم إلى الطابور',
      'leave_queue': 'غادر الطابور',
      'queue_details': 'تفاصيل الطابور',
      'queue_settings': 'إعدادات الطابور',
      'join_queue_confirm': 'هل أنت متأكد أنك تريد الانضمام إلى هذا الطابور؟',
      'join_queue_description': 'تصفّح الطوابير المتاحة وانضم إلى ما تحتاجه.',
      'queue_tips': 'معلومة: احرص على الحضور في الوقت المحدد وتحقق من هاتفك للإشعارات.',
      'refreshed': 'تم التحديث',
      'leave_queue_confirm': 'هل أنت متأكد أنك تريد مغادرة هذا الطابور؟',
      'position': 'الموضع',
      'not_joined': 'غير منضم',
      'view_details': 'عرض التفاصيل',
      'no_results': 'لم يتم العثور على نتائج',
      'no_available_queues': 'لا توجد طوابير متاحة في الوقت الحالي',
      'try_different_search': 'حاول مصطلح بحث مختلف',
      'check_back_later': 'يرجى المحاولة لاحقًا',
      'add_queue_hint': 'أنشئ أول طابور لبدء خدمة العملاء',
      'delete_queue_confirm': 'هل أنت متأكد أنك تريد حذف هذا الطابور؟',
      'serve_confirm': 'خدمة',
      'notify_confirm': 'تنبيه',
      'remove_confirm': 'إزالة',
      'served_at': 'تمت الخدمة في',
      'notified_at': 'تم التنبيه في',
      'spots_available': 'مقاعد متاحة',
      'customers': 'عملاء',
      'no_customers': 'لا يوجد عملاء في الطابور',
      'add_customer_hint': 'أضف العملاء يدويًا من هنا',
      'capacity': 'السعة',
      'avg_time': 'الوقت المتوسط',
      'max_queues_reached': 'يمكنك الانضمام إلى 3 طوابير كحد أقصى',
      'manage_queue': 'إدارة الطابور',
      'manage_your_queues': 'إدارة طوابيرك',
      
      // Search & Discovery
      'search_hint': 'ابحث عن عمل...',
      'search_queues': 'ابحث في الطوابير...',
      'search_businesses': 'ابحث عن الأعمال...',
      'nearby_businesses': 'الأعمال القريبة',
      'popular_queues': 'الطوابير الشائعة',
      'recommended': 'موصى به',
      'recent': 'الأخيرة',
      'total_customers': 'إجمالي العملاء',
      
      // Notifications & Status
      'queue_created': 'تم إنشاء الطابور بنجاح',
      'queue_deleted': 'تم حذف الطابور بنجاح',
      'queue_updated': 'تم تحديث الطابور بنجاح',
      'person_added': 'تمت إضافة الشخص إلى الطابور',
      'person_removed': 'تم إزالة الشخص من الطابور',
      'joined_queue': 'لقد انضممت إلى الطابور',
      'left_queue': 'لقد غادرت الطابور',
      'queue_full_error': 'الطابور ممتلئ',
      'position_updated': 'تم تحديث الموضع',
      'turn_soon': 'دورك قريب',
      'your_turn': 'حان دورك!',
      'missed_turn': 'لقد فاتك دورك',
      'notification': 'إشعار',
      'notifications': 'الإشعارات',
      
      // Settings & Help
      'settings': 'الإعدادات',
      'help': 'المساعدة والدعم',
      'about': 'حول التطبيق',
      'contact_support': 'اتصل بالدعم',
      'email_support': 'بريد الدعم',
      'call_support': 'اتصل بنا',
      'dev_team': 'فريق التطوير',
      'about_project': 'حول المشروع',
      'version': 'إصدار 1.0.0',
      'privacy_policy': 'سياسة الخصوصية',
      'terms_of_service': 'شروط الخدمة',
      'faq': 'الأسئلة الشائعة',
      'support': 'الدعم',
      'feedback': 'التقييم',
      'rate_app': 'قيم التطبيق',
      'share_app': 'شارك التطبيق',
      
      // Business Specific
      'business_info': 'معلومات العمل',
      'business_type': 'نوع العمل',
      'address': 'العنوان',
      'location': 'الموقع',
      'business_hours': 'ساعات العمل',
      'manage_queues': 'إدارة الطوابير',
      'customer_management': 'إدارة العملاء',
      'business_settings': 'إعدادات العمل',
      'business_profile': 'ملف العمل',
      
      // Time & Status
      'active': 'نشط',
      'inactive': 'غير نشط',
      'paused': 'متوقف',
      'closed': 'مغلق',
      'today': 'اليوم',
      'tomorrow': 'غداً',
      'yesterday': 'أمس',
      'now': 'الآن',
      'soon': 'قريباً',
      'later': 'لاحقاً',
      'status': 'الحالة',
      'cancelled': 'ملغي',
      'missed': 'فات',
      
      // Validation Messages
      'required_field': 'هذا الحقل مطلوب',
      'invalid_email': 'بريد إلكتروني غير صالح',
      'invalid_phone': 'رقم هاتف غير صالح',
      'phone_too_short': 'رقم الهاتف قصير جداً',
      'password_too_short': 'كلمة المرور يجب أن تحتوي على 6 أحرف على الأقل',
      'passwords_not_match': 'كلمات المرور غير متطابقة',
      'invalid_name': 'الاسم يجب أن يحتوي على 3 أحرف على الأقل',
      
      // Actions
      'view': 'عرض',
      'remove': 'إزالة',
      'clear': 'مسح',
      'select': 'اختر',
      'choose': 'اختر',
      'browse': 'تصفح',
      'upload': 'رفع',
      'download': 'تحميل',
      'share': 'مشاركة',
      'copy': 'نسخ',
      'paste': 'لصق',
    },
  };

  // Set the current locale
  void setLocale(Locale locale) {
    if (supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      _currentLocale = locale;
    } else {
      _currentLocale = const Locale('en');
    }
  }

  // Get translation for a key
  String get(String key) {
    try {
      return _localizedValues[_currentLocale.languageCode]?[key] ?? 
             _localizedValues['en']?[key] ?? 
             key;
    } catch (e) {
      return key;
    }
  }

  // Static method to get translation (for convenience)
  static String getTranslation(String key) {
    try {
      return _localizedValues[_instance._currentLocale.languageCode]?[key] ??
             _localizedValues['en']?[key] ??
             key;
    } catch (e) {
      return key;
    }
  }

  // Get current locale
  Locale get currentLocale => _currentLocale;

  // Check if current locale is RTL
  bool get isRTL => _currentLocale.languageCode == 'ar';

  // Get supported locales
  List<Locale> get supportedLocalesList => supportedLocales;

  // Get language name for a locale code
  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en': return 'English';
      case 'fr': return 'Français';
      case 'ar': return 'العربية';
      default: return 'English';
    }
  }

  // Get language flag for a locale code
  String getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'en': return '🇺🇸';
      case 'fr': return '🇫🇷';
      case 'ar': return '🇸🇦';
      default: return '🇺🇸';
    }
  }

  // Get QNowLocalizations instance from context
  static QNowLocalizations of(BuildContext context) {
    return _instance;
  }

  // Clear all translations (for testing)
  static void clear() {
    // This is useful for testing purposes
  }
}

// Simple extension for easy access in widgets
extension LocalizationExtension on BuildContext {
  String loc(String key) {
    return QNowLocalizations.getTranslation(key);
  }

  QNowLocalizations get localizations => QNowLocalizations.of(this);
}

// Localized Text Widget
class LocalizedText extends StatelessWidget {
  final String ke;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedText(
    this.ke
    , {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      context.loc(ke),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// Localized Button Widget
class LocalizedButton extends StatelessWidget {
  final String textKey;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final bool isLoading;

  const LocalizedButton({
    super.key,
    required this.textKey,
    required this.onPressed,
    this.style,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? const CircularProgressIndicator()
          : LocalizedText(textKey),
    );
  }
}

// Localized Input Field Widget
class LocalizedTextField extends StatelessWidget {
  final String hintKey;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const LocalizedTextField({
    super.key,
    required this.hintKey,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: context.loc(hintKey),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}

// Also provide the same helper on Element and State so calls that have
// a more specific static type (e.g. StatefulElement) still resolve to
// a localization helper when using the dot syntax.
extension LocalizationOnElement on Element {
  String loc(String key) => QNowLocalizations.getTranslation(key);
}

extension LocalizationOnState<T extends StatefulWidget> on State<T> {
  String loc(String key) => QNowLocalizations.getTranslation(key);
}