import 'package:flutter/material.dart';

class QNowLocalizations {
  static final QNowLocalizations _instance = QNowLocalizations._internal();
  factory QNowLocalizations() => _instance;
  QNowLocalizations._internal();

  Locale _currentLocale = const Locale('en');

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App and General
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

      // Authentication and Roles
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
      'enter_email_reset':
          'Enter your email address to receive a password reset link',
      'send_reset_link': 'Send Reset Link',
      'reset_email_sent': 'Password reset link sent! Check your email.',
      'reset_email_error': 'Failed to send reset email. Please try again.',
      'email_required': 'Email is required',

      // User Information
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
      'available': 'Available',
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
      'join_queue_description':
          'Browse available queues and join the ones you need.',
      'queue_tips':
          'Tip: Arrive on time and keep your phone handy for notifications.',
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
      'already_served_and_joined':
          'You have already joined this queue and have been served',
      'already_in_queue': 'You are already in this queue',
      'queue_details': 'Queue Details',
      'queue_settings': 'Queue Settings',
      'manage_queue': 'Manage Queue',
      'manage_your_queues': 'Manage Your Queues',

      // Search and Discovery
      'search_hint': 'Search for business...',
      'search_queues': 'Search queues...',
      'search_businesses': 'Search businesses...',
      'nearby_businesses': 'Nearby Businesses',
      'popular_queues': 'Popular Queues',
      'recommended': 'Recommended',
      'recent': 'Recent',

      // Large Messages
      'privacy_policy_message':
          'We respect your privacy. This app stores necessary user data (name, phone, and optional email/business info) locally to provide queue services. Data is used only for functionality and not shared externally.',
      'terms_of_service_message':
          'By using QNow, you agree to join, leave, and manage queues responsibly. Do not misuse the app or provide false information. We may update these terms as needed.',

      // Help and About (About page texts)
      'smart_queue_title': 'Smart Queue Management System',
      'smart_queue_description':
          'QNow revolutionizes the way people wait in queues. Our digital solution eliminates physical waiting, saving time and improving customer experience.',
      'key_features': 'Key Features',
      'feature_realtime': 'Real-time Queue Tracking',
      'feature_realtime_desc': 'Monitor your position in real-time',
      'feature_notifications': 'Smart Notifications',
      'feature_notifications_desc': 'Get notified when your turn is near',
      'feature_business_management': 'Business Management',
      'feature_business_management_desc': 'Manage multiple queues efficiently',
      'feature_multilanguage': 'Multi-language Support',
      'feature_multilanguage_desc': 'Available in English, French, and Arabic',
      'contact_us': 'Contact Us',
      'copyright_text': '© 2025 QNow. All rights reserved.',

      // Notifications and Status
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
      'manual': 'Manual',
      'notifications': 'Notifications',
      'queue_notifications': 'Queue Notifications',
      'queue_notifications_subtitle': 'Get notified when your turn is near',
      'promotional_notifications': 'Promotional Notifications',
      'promotional_notifications_subtitle': 'Receive offers and updates',
      'sound_alerts': 'Sound Alerts',
      'sound_alerts_subtitle': 'Play sound for notifications',
      'notification_sent_successfully': 'Notification sent successfully',
      'notification_failed': 'Failed to send notification',
      'user_no_notifications': 'User has notifications disabled',
      'sending_notification': 'Sending notification...',
      'notify_customer': 'Notify Customer',
      'manual_customer_notified': 'Manual customer notified (no push notification)',
      'customer_notified_no_user': 'Customer marked as notified (no registered user)',

      // Settings and Help
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',
      'settings': 'Settings',
      'privacy_security': 'Privacy and Security',
      'delete_account': 'Delete Account',
      'help': 'Help and Support',
      'about': 'About Us',
      'contact_support': 'Contact Support',
      'email_support': 'Email Support',
      'call_support': 'Call Support',
      'dev_team': 'Development Team',
      'about_project': 'About The Project',
      'version': 'Version 1.0.0',
      'faq': 'FAQ',
      'support': 'Support',
      'feedback': 'Feedback',
      'rate_app': 'Rate App',
      'share_app': 'Share App',
      'profile_updated': 'Profile Updated',
      'password_changed': 'Password changed successfully',
      'change': 'Change',

      // Help and Support
      'additional_resources': 'Additional Resources',
      'user_guide': 'User Guide',
      'report_bug': 'Report a Bug',
      'send_feedback': 'Send Feedback',
      'how_do_i_join_queue': 'How do I join a queue?',
      'join_queue_answer':
          'To join a queue, navigate to the business you want to visit, find the queue, and tap "Join Queue". You will receive notifications when your turn is approaching.',
      'can_i_leave_queue': 'Can I leave a queue?',
      'leave_queue_answer':
          'Yes, you can leave a queue at any time by going to your active queues and tapping the "Leave" button. Your position will be freed up for other customers.',
      'manage_notifications': 'How do I manage notifications?',
      'manage_notifications_answer':
          'Go to Settings > Notifications to manage all notification preferences. You can enable or disable queue notifications, promotional messages, and sound alerts.',
      'data_security': 'Is my data secure?',
      'data_security_answer':
          'Yes, we use industry-standard encryption to protect your personal data. See our Privacy Policy for more details on how we handle your information.',
      'learn_more': 'Learn More',
      'help_center': 'Help Center',

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

      // Time and Status
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
      'analytics': 'Analytics',
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
      // App and General
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

      // Authentication and Roles
      'login': 'Connexion',
      'signup': 'S\'inscrire',
      'sign_out': 'Déconnexion',
      'business_owner': 'Entrepreneur',
      'customer': 'Client',
      'email': 'E-mail',
      'password': 'Mot de passe',
      'confirm_password': 'Confirmer le mot de passe',
      'forgot_password': 'Mot de passe oublié ?',
      'dont_have_account': 'Vous n\'avez pas de compte ?',
      'already_have_account': 'Vous avez déjà un compte ?',
      'create_account': 'Créer un compte',
      'reset_password': 'Réinitialiser le mot de passe',
      'enter_email_reset':
          'Entrez votre adresse e-mail pour recevoir un lien de réinitialisation',
      'send_reset_link': 'Envoyer le lien',
      'reset_email_sent':
          'Lien de réinitialisation envoyé ! Vérifiez votre e-mail.',
      'reset_email_error':
          'Échec de l\'envoi de l\'e-mail. Veuillez réessayer.',
      'email_required': 'L\'e-mail est requis',

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
      'available': 'Disponible',
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
      'join_queue_description':
          'Parcourez les files disponibles et rejoignez celles dont vous avez besoin.',
      'queue_tips':
          'Conseil : Arrivez à l’heure et gardez votre téléphone à portée de main pour les notifications.',
      'refreshed': 'Actualisé',
      'leave_queue_confirm': 'Êtes-vous sûr de vouloir quitter cette file ?',
      'position': 'Position',
      'not_joined': 'Non rejoint',
      'view_details': 'Voir les détails',
      'no_results': 'Aucun résultat trouvé',
      'no_available_queues': 'Aucune file disponible pour le moment',
      'try_different_search': 'Essayez un terme de recherche différent',
      'check_back_later': 'Veuillez revenir plus tard',
      'add_queue_hint':
          'Créez votre première file pour commencer à servir des clients',
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
      'already_served_and_joined':
          'Vous avez déjà rejoint cette file et avez été servi',
      'already_in_queue': 'Vous êtes déjà dans cette file',
      'manage_queue': 'Gérer la file',
      'manage_your_queues': 'Gérer vos files',
      'total_customers': 'Total Clients',

      // Search and Discovery
      'search_hint': 'Rechercher une entreprise...',
      'search_queues': 'Rechercher des files...',
      'search_businesses': 'Rechercher des entreprises...',
      'nearby_businesses': 'Entreprises à proximité',
      'popular_queues': 'Files populaires',
      'recommended': 'Recommandé',
      'recent': 'Récent',

      // Large Messages
      'privacy_policy_message':
          'Nous respectons votre vie privée. Cette application stocke localement les données utilisateur nécessaires (nom, téléphone et informations facultatives sur l\'e-mail/l\'entreprise) pour fournir des services de file d\'attente. Les données sont utilisées uniquement pour la fonctionnalité et ne sont pas partagées à l\'extérieur.',
      'terms_of_service_message':
          'En utilisant QNow, vous acceptez de rejoindre, quitter et gérer les files de manière responsable. N\'abusez pas de l\'application et ne fournissez pas de fausses informations. Nous pouvons mettre à jour ces conditions si nécessaire.',
      // Help and About (About page texts)
      'smart_queue_title':
          'Système de gestion intelligente de files d\'attente',
      'smart_queue_description':
          'QNow révolutionne la façon dont les gens attendent dans les files. Notre solution digitale élimine l\'attente physique, faisant gagner du temps et améliorant l\'expérience client.',
      'key_features': 'Fonctionnalités clés',
      'feature_realtime': 'Suivi des files en temps réel',
      'feature_realtime_desc': 'Surveillez votre position en temps réel',
      'feature_notifications': 'Notifications intelligentes',
      'feature_notifications_desc':
          'Recevez une notification lorsque votre tour approche',
      'feature_business_management': 'Gestion des entreprises',
      'feature_business_management_desc': 'Gérez plusieurs files efficacement',
      'feature_multilanguage': 'Support multilingue',
      'feature_multilanguage_desc': 'Disponible en anglais, français et arabe',
      'contact_us': 'Contactez-nous',
      'copyright_text': '© 2025 QNow. Tous droits réservés.',

      // Notifications and Status
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
      'queue_notifications': 'Notifications de file',
      'queue_notifications_subtitle': 'Être averti quand votre tour approche',
      'promotional_notifications': 'Notifications promotionnelles',
      'promotional_notifications_subtitle':
          'Recevoir des offres et mises à jour',
      'sound_alerts': 'Alertes sonores',
      'sound_alerts_subtitle': 'Jouer un son pour les notifications',
      'notification_sent_successfully': 'Notification envoyée avec succès',
      'notification_failed': 'Échec de l\'envoi de la notification',
      'user_no_notifications': 'L\'utilisateur a désactivé les notifications',
      'sending_notification': 'Envoi de la notification...',
      'notify_customer': 'Notifier le client',
      'manual_customer_notified': 'Client manuel notifié (pas de notification push)',
      'customer_notified_no_user': 'Client marqué comme notifié (pas d\'utilisateur enregistré)',

      // Settings and Help
      'privacy_policy': 'Politique de confidentialité',
      'terms_of_service': 'Conditions d\'utilisation',
      'settings': 'Paramètres',
      'privacy_security': 'Confidentialité et sécurité',
      'delete_account': 'Supprimer le compte',
      'help': 'Aide and Support',
      'about': 'À propos',
      'contact_support': 'Contacter le support',
      'email_support': 'Email Support',
      'call_support': 'Appeler le support',
      'dev_team': 'Équipe de développement',
      'about_project': 'À propos du projet',
      'version': 'Version 1.0.0',
      'faq': 'FAQ',
      'support': 'Support',
      'feedback': 'Retour',
      'rate_app': 'Noter l\'app',
      'share_app': 'Partager l\'app',
      'profile_updated': 'Profil changé',
      'password_changed': 'Mot de passe changé avec succès',
      'change': 'Changer',
      'analytics': 'Analytique',

      // Help and Support
      'additional_resources': 'Ressources supplémentaires',
      'user_guide': 'Guide de l\'utilisateur',
      'report_bug': 'Signaler un bug',
      'send_feedback': 'Envoyer des commentaires',
      'how_do_i_join_queue': 'Comment rejoindre une file ?',
      'join_queue_answer':
          'Pour rejoindre une file, accédez à l\'entreprise que vous souhaitez visiter, trouvez la file et appuyez sur "Rejoindre la file". Vous recevrez des notifications lorsque votre tour approche.',
      'can_i_leave_queue': 'Puis-je quitter une file ?',
      'leave_queue_answer':
          'Oui, vous pouvez quitter une file à tout moment en appuyant sur "Quitter la file".',
      'manage_notifications': 'Comment gérer les notifications ?',
      'manage_notifications_answer':
          'Allez dans Paramètres > Notifications pour gérer toutes les préférences de notification. Vous pouvez activer ou désactiver les notifications de file, les messages promotionnels et les alertes sonores.',
      'data_security': 'Mes données sont-elles sécurisées ?',
      'data_security_answer':
          'Oui, nous utilisons un cryptage standard de l\'industrie pour protéger vos données personnelles. Consultez notre politique de confidentialité pour plus de détails sur la façon dont nous gérons vos informations.',
      'learn_more': 'En savoir plus',
      'help_center': 'Centre d\'aide',

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

      // Time and Status
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
      'password_too_short':
          'Le mot de passe doit contenir au moins 6 caractères',
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
      // App and General
      'app_title': 'كيو ناو',
      'welcome': 'مرحباً',
      'loading': 'جاري التحميل...',
      'empty': 'لم يتم العثور على عناصر',
      'error': 'خطأ',
      'success': 'نجاح',
      'manual': 'يدوياً',
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
      'already_served_and_joined':
          'لقد انضممت بالفعل إلى هذه الطابور وتمت خدمتك',
      'already_in_queue': 'أنت بالفعل في هذا الطابور',
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

      // Authentication and Roles
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
      'enter_email_reset':
          'أدخل عنوان بريدك الإلكتروني لتلقي رابط إعادة تعيين كلمة المرور',
      'send_reset_link': 'إرسال الرابط',
      'reset_email_sent':
          'تم إرسال رابط إعادة التعيين! تحقق من بريدك الإلكتروني.',
      'reset_email_error':
          'فشل إرسال البريد الإلكتروني. يرجى المحاولة مرة أخرى.',
      'email_required': 'البريد الإلكتروني مطلوب',

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
      'available': 'متاح',
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
      'queue_tips':
          'معلومة: احرص على الحضور في الوقت المحدد وتحقق من هاتفك للإشعارات.',
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

      // Search and Discovery
      'search_hint': 'ابحث عن عمل...',
      'search_queues': 'ابحث في الطوابير...',
      'search_businesses': 'ابحث عن الأعمال...',
      'nearby_businesses': 'الأعمال القريبة',
      'popular_queues': 'الطوابير الشائعة',
      'recommended': 'موصى به',
      'recent': 'الأخيرة',
      'total_customers': 'إجمالي العملاء',

      // Large Messages
      'privacy_policy_message':
          'نحن نحترم خصوصيتك. يقوم هذا التطبيق بتخزين بيانات المستخدم الضرورية (الاسم، الهاتف، ومعلومات البريد الإلكتروني/العمل الاختيارية) محليًا لتوفير خدمات الطابور. تُستخدم البيانات فقط للوظائف ولا تتم مشاركتها خارجيًا.',
      'terms_of_service_message':
          'باستخدام QNow، فإنك توافق على الانضمام، والمغادرة، وإدارة الطوابير بمسؤولية. لا تسيء استخدام التطبيق أو تقدم معلومات خاطئة. قد نقوم بتحديث هذه الشروط حسب الحاجة.',

      // Help and About (About page texts)
      'smart_queue_title': 'نظام إدارة الطوابير الذكي',
      'smart_queue_description':
          'QNow يُحدث ثورة في طريقة انتظار الناس في الطوابير. تزيل حلنا الرقمي الانتظار المادي، مما يوفر الوقت ويحسن تجربة العملاء.',
      'key_features': 'الميزات الرئيسية',
      'feature_realtime': 'تتبع الطابور في الوقت الحقيقي',
      'feature_realtime_desc': 'راقب موقعك في الوقت الحقيقي',
      'feature_notifications': 'إشعارات ذكية',
      'feature_notifications_desc': 'ستتلقى إشعارًا عند اقتراب دورك',
      'feature_business_management': 'إدارة الأعمال',
      'feature_business_management_desc': 'إدارة طوابير متعددة بكفاءة',
      'feature_multilanguage': 'دعم متعدد اللغات',
      'feature_multilanguage_desc': 'متاح بالإنجليزية والفرنسية والعربية',
      'contact_us': 'اتصل بنا',
      'copyright_text': '© 2025 QNow. كل الحقوق محفوظة.',
      'analytics': 'التحليلات',

      // Notifications and Status
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
      'queue_notifications': 'إشعارات الطابور',
      'queue_notifications_subtitle': 'احصل على إشعار عندما يقترب دورك',
      'promotional_notifications': 'الإشعارات الترويجية',
      'promotional_notifications_subtitle': 'تلقي العروض والتحديثات',
      'sound_alerts': 'التنبيهات الصوتية',
      'sound_alerts_subtitle': 'تشغيل الصوت للإشعارات',
      'notification_sent_successfully': 'تم إرسال الإشعار بنجاح',
      'notification_failed': 'فشل إرسال الإشعار',
      'user_no_notifications': 'قام المستخدم بتعطيل الإشعارات',
      'sending_notification': 'جاري إرسال الإشعار...',
      'notify_customer': 'تنبيه العميل',
      'manual_customer_notified': 'تم تنبيه العميل اليدوي (بدون إشعار دفع)',
      'customer_notified_no_user': 'تم وضع علامة على العميل كمنبه (لا يوجد مستخدم مسجل)',

      // Settings and Help
      'privacy_policy': 'سياسة الخصوصية',
      'terms_of_service': 'شروط الخدمة',
      'settings': 'الإعدادات',
      'privacy_security': 'الخصوصية والأمان',
      'delete_account': 'حذف الحساب',
      'help': 'المساعدة والدعم',
      'about': 'حول التطبيق',
      'contact_support': 'اتصل بالدعم',
      'email_support': 'بريد الدعم',
      'call_support': 'اتصل بنا',
      'dev_team': 'فريق التطوير',
      'about_project': 'حول المشروع',
      'version': 'إصدار 1.0.0',
      'faq': 'الأسئلة الشائعة',
      'support': 'الدعم',
      'feedback': 'التقييم',
      'rate_app': 'قيم التطبيق',
      'share_app': 'شارك التطبيق',
      'profile_updated': 'تم تحديث الملف الشخصي',
      'password_changed': 'تم تغيير كلمة المرور بنجاح',
      'change': 'تغيير',

      // Help and Support
      'additional_resources': 'موارد إضافية',
      'user_guide': 'دليل المستخدم',
      'report_bug': 'الإبلاغ عن خطأ',
      'send_feedback': 'إرسال ملاحظات',
      'how_do_i_join_queue': 'كيف أنضم إلى طابور؟',
      'join_queue_answer':
          'للإنضمام إلى طابور، انتقل إلى العمل الذي ترغب في زيارته، ابحث عن الطابور، واضغط على "انضم إلى الطابور". ستتلقى إشعارات عندما يقترب دورك.',
      'can_i_leave_queue': 'هل يمكنني مغادرة الطابور؟',
      'leave_queue_answer':
          'نعم، يمكنك مغادرة الطابور في أي وقت من خلال الذهاب إلى الطوابير النشطة الخاصة بك والنقر على زر "غادر". سيتم تحرير موقعك للعملاء الآخرين.',
      'manage_notifications': 'كيف أدير الإشعارات؟',
      'manage_notifications_answer':
          'اذهب إلى الإعدادات > الإشعارات لإدارة جميع تفضيلات الإشعارات. يمكنك تمكين أو تعطيل إشعارات الطابور، الرسائل الترويجية، والتنبيهات الصوتية.',
      'data_security': 'هل بياناتي آمنة؟',
      'data_security_answer':
          'نعم، نحن نستخدم تشفيرًا قياسيًا في الصناعة لحماية بياناتك الشخصية. راجع سياسة الخصوصية الخاصة بنا لمزيد من التفاصيل حول كيفية تعاملنا مع معلوماتك.',
      'learn_more': 'تعرف على المزيد',
      'help_center': 'مركز المساعدة',

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

      // Time and Status
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

  void setLocale(Locale locale) {
    if (supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      _currentLocale = locale;
    } else {
      _currentLocale = const Locale('en');
    }
  }

  String get(String key) {
    try {
      return _localizedValues[_currentLocale.languageCode]?[key] ??
          _localizedValues['en']?[key] ??
          key;
    } catch (e) {
      return key;
    }
  }

  static String getTranslation(String key) {
    try {
      return _localizedValues[_instance._currentLocale.languageCode]?[key] ??
          _localizedValues['en']?[key] ??
          key;
    } catch (e) {
      return key;
    }
  }

  Locale get currentLocale => _currentLocale;

  bool get isRTL => _currentLocale.languageCode == 'ar';

  List<Locale> get supportedLocalesList => supportedLocales;

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }

  String getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'fr':
        return '🇫🇷';
      case 'ar':
        return '🇩🇿';
      default:
        return '🇺🇸';
    }
  }

  static QNowLocalizations of(BuildContext context) {
    return _instance;
  }

  static void clear() {}
}

extension LocalizationExtension on BuildContext {
  String loc(String key) {
    return QNowLocalizations.getTranslation(key);
  }

  QNowLocalizations get localizations => QNowLocalizations.of(this);
}

// Text Widget
class LocalizedText extends StatelessWidget {
  final String ke;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedText(
    this.ke, {
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

// Button Widget
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

// Input Field Widget
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

extension LocalizationOnElement on Element {
  String loc(String key) => QNowLocalizations.getTranslation(key);
}

extension LocalizationOnState<T extends StatefulWidget> on State<T> {
  String loc(String key) => QNowLocalizations.getTranslation(key);
}
