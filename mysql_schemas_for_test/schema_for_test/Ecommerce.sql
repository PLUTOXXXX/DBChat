DROP SCHEMA IF EXISTS Ecommerce;
CREATE DATABASE Ecommerce;
USE Ecommerce;

# --------------------------------------------------------
#
# Table structure for table upgrade_exceptions
# (Placed at top so any exceptions during installation can be trapped as well)
#

DROP TABLE IF EXISTS upgrade_exceptions;
CREATE TABLE upgrade_exceptions (
  upgrade_exception_id smallint(5) NOT NULL auto_increment,
  sql_file varchar(50) default NULL,
  reason varchar(200) default NULL,
  errordate datetime default '1000-01-01 00:00:00',
  sqlstatement text,
  PRIMARY KEY  (upgrade_exception_id)
) ;


# --------------------------------------------------------
#
# Table structure for table address_book
#

DROP TABLE IF EXISTS address_book;
CREATE TABLE address_book (
  address_book_id int(11) NOT NULL auto_increment,
  customers_id int(11) NOT NULL default '0',
  entry_gender char(1) NOT NULL default '',
  entry_company varchar(64) default NULL,
  entry_firstname varchar(32) NOT NULL default '',
  entry_lastname varchar(32) NOT NULL default '',
  entry_street_address varchar(64) NOT NULL default '',
  entry_suburb varchar(32) default NULL,
  entry_postcode varchar(10) NOT NULL default '',
  entry_city varchar(32) NOT NULL default '',
  entry_state varchar(32) default NULL,
  entry_country_id int(11) NOT NULL default '0',
  entry_zone_id int(11) NOT NULL default '0',
  PRIMARY KEY  (address_book_id),
  KEY idx_address_book_customers_id_zen (customers_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'address_format'
#

DROP TABLE IF EXISTS address_format;
CREATE TABLE address_format (
  address_format_id int(11) NOT NULL auto_increment,
  address_format varchar(128) NOT NULL default '',
  address_summary varchar(48) NOT NULL default '',
  PRIMARY KEY  (address_format_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'admin'
#

DROP TABLE IF EXISTS admin;
CREATE TABLE admin (
  admin_id int(11) NOT NULL auto_increment,
  admin_name varchar(32) NOT NULL default '',
  admin_email varchar(96) NOT NULL default '',
  admin_profile int(11) NOT NULL default '0',
  admin_pass varchar(40) NOT NULL default '',
  prev_pass1 varchar(40) NOT NULL default '',
  prev_pass2 varchar(40) NOT NULL default '',
  prev_pass3 varchar(40) NOT NULL default '',
  pwd_last_change_date datetime NOT NULL default '1000-01-01 00:00:00',
  reset_token varchar(60) NOT NULL default '',
  last_modified datetime NOT NULL default '1000-01-01 00:00:00',
  last_login_date datetime NOT NULL default '1000-01-01 00:00:00',
  last_login_ip varchar(15) NOT NULL default '',
  failed_logins smallint(4) unsigned NOT NULL default '0',
  lockout_expires int(11) NOT NULL default '0',
  last_failed_attempt datetime NOT NULL default '1000-01-01 00:00:00',
  last_failed_ip varchar(15) NOT NULL default '',
  PRIMARY KEY  (admin_id),
  KEY idx_admin_name_zen (admin_name),
  KEY idx_admin_email_zen (admin_email),
  KEY idx_admin_profile_zen (admin_profile)
) ;

# --------------------------------------------------------

#
# Table structure for table 'admin_activity_log'
#

DROP TABLE IF EXISTS admin_activity_log;
CREATE TABLE admin_activity_log (
  log_id bigint(15) NOT NULL auto_increment,
  access_date datetime NOT NULL default '1000-01-01 00:00:00',
  admin_id int(11) NOT NULL default '0',
  page_accessed varchar(80) NOT NULL default '',
  page_parameters text,
  ip_address varchar(20) NOT NULL default '',
  flagged tinyint NOT NULL default '0',
  attention varchar(255) NOT NULL default '',
  PRIMARY KEY  (log_id),
  KEY idx_page_accessed_zen (page_accessed),
  KEY idx_access_date_zen (access_date),
  KEY idx_flagged_zen (flagged),
  KEY idx_ip_zen (ip_address)
) ;

# --------------------------------------------------------

#
# Table structure for table 'admin_menu'
#

DROP TABLE IF EXISTS admin_menus;
CREATE TABLE admin_menus (
  menu_key VARCHAR(32) NOT NULL DEFAULT '',
  language_key VARCHAR(255) NOT NULL DEFAULT '',
  sort_order INT(11) NOT NULL DEFAULT 0,
  UNIQUE KEY menu_key (menu_key)
) ;

# --------------------------------------------------------

#
# Table structure for table 'admin_pages'
#

DROP TABLE IF EXISTS admin_pages;
CREATE TABLE admin_pages (
  page_key VARCHAR(32) NOT NULL DEFAULT '',
  language_key VARCHAR(255) NOT NULL DEFAULT '',
  main_page varchar(64) NOT NULL default '',
  page_params varchar(64) NOT NULL default '',
  menu_key varchar(32) NOT NULL default '',
  display_on_menu char(1) NOT NULL default 'N',
  sort_order int(11) NOT NULL default 0,
  UNIQUE KEY page_key (page_key)
) ;

# --------------------------------------------------------

#
# Table structure for table 'admin_profiles'
#

DROP TABLE IF EXISTS admin_profiles;
CREATE TABLE admin_profiles (
  profile_id int(11) NOT NULL AUTO_INCREMENT,
  profile_name varchar(64) NOT NULL default '',
  PRIMARY KEY (profile_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'admin_pages_to_profiles'
#

DROP TABLE IF EXISTS admin_pages_to_profiles;
CREATE TABLE admin_pages_to_profiles (
  profile_id int(11) NOT NULL default '0',
  page_key varchar(32) NOT NULL default '',
  UNIQUE KEY profile_page (profile_id, page_key),
  UNIQUE KEY page_profile (page_key, profile_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'authorizenet'
#
DROP TABLE IF EXISTS authorizenet;
CREATE TABLE authorizenet (
  id int(11) unsigned NOT NULL auto_increment,
  customer_id int(11) NOT NULL default '0',
  order_id int(11) NOT NULL default '0',
  response_code int(1) NOT NULL default '0',
  response_text varchar(255) NOT NULL default '',
  authorization_type varchar(50) NOT NULL default '',
  transaction_id bigint(20) default NULL,
  sent longtext NOT NULL,
  received longtext NOT NULL,
  time varchar(50) NOT NULL default '',
  session_id varchar(255) NOT NULL default '',
  PRIMARY KEY  (id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'banners'
#

DROP TABLE IF EXISTS banners;
CREATE TABLE banners (
  banners_id int(11) NOT NULL auto_increment,
  banners_title varchar(64) NOT NULL default '',
  banners_url varchar(255) NOT NULL default '',
  banners_image varchar(64) NOT NULL default '',
  banners_group varchar(15) NOT NULL default '',
  banners_html_text text,
  expires_impressions int(7) default '0',
  expires_date datetime default NULL,
  date_scheduled datetime default NULL,
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  date_status_change datetime default NULL,
  status int(1) NOT NULL default '1',
  banners_open_new_windows int(1) NOT NULL default '1',
  banners_on_ssl int(1) NOT NULL default '1',
  banners_sort_order int(11) NOT NULL default '0',
  PRIMARY KEY  (banners_id),
  KEY idx_status_group_zen (status,banners_group),
  KEY idx_expires_date_zen (expires_date),
  KEY idx_date_scheduled_zen (date_scheduled)
) ;


# --------------------------------------------------------

#
# Table structure for table 'banners_history'
#

DROP TABLE IF EXISTS banners_history;
CREATE TABLE banners_history (
  banners_history_id int(11) NOT NULL auto_increment,
  banners_id int(11) NOT NULL default '0',
  banners_shown int(5) NOT NULL default '0',
  banners_clicked int(5) NOT NULL default '0',
  banners_history_date datetime NOT NULL default '1000-01-01 00:00:00',
  PRIMARY KEY  (banners_history_id),
  KEY idx_banners_id_zen (banners_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'categories'
#

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
  categories_id int(11) NOT NULL auto_increment,
  categories_image varchar(64) default NULL,
  parent_id int(11) NOT NULL default '0',
  sort_order int(3) default NULL,
  date_added datetime default NULL,
  last_modified datetime default NULL,
  categories_status tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (categories_id),
  KEY idx_parent_id_cat_id_zen (parent_id,categories_id),
  KEY idx_status_zen (categories_status),
  KEY idx_sort_order_zen (sort_order)
) ;

# --------------------------------------------------------

#
# Table structure for table 'categories_description'
#

DROP TABLE IF EXISTS categories_description;
CREATE TABLE categories_description (
  categories_id int(11) NOT NULL default '0',
  language_id int(11) NOT NULL default '1',
  categories_name varchar(32) NOT NULL default '',
  categories_description text NOT NULL,
  PRIMARY KEY  (categories_id,language_id),
  KEY idx_categories_name_zen (categories_name),
  foreign key (categories_id) references categories(categories_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'configuration'
#

DROP TABLE IF EXISTS configuration;
CREATE TABLE configuration (
  configuration_id int(11) NOT NULL auto_increment,
  configuration_title text NOT NULL,
  configuration_key varchar(255) NOT NULL default '',
  configuration_value text NOT NULL,
  configuration_description text NOT NULL,
  configuration_group_id int(11) NOT NULL default '0',
  sort_order int(5) default NULL,
  last_modified datetime default NULL,
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  use_function text default NULL,
  set_function text default NULL,
  PRIMARY KEY  (configuration_id),
  UNIQUE KEY unq_config_key_zen (configuration_key),
  KEY idx_key_value_zen (configuration_key,configuration_value(10)),
  KEY idx_cfg_grp_id_zen (configuration_group_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'configuration_group'
#

DROP TABLE IF EXISTS configuration_group;
CREATE TABLE configuration_group (
  configuration_group_id int(11) NOT NULL auto_increment,
  configuration_group_title varchar(64) NOT NULL default '',
  configuration_group_description varchar(255) NOT NULL default '',
  sort_order int(5) default NULL,
  visible int(1) default '1',
  PRIMARY KEY  (configuration_group_id),
  KEY idx_visible_zen (visible)
) ;

# --------------------------------------------------------

#
# Table structure for table 'counter'
#

DROP TABLE IF EXISTS counter;
CREATE TABLE counter (
  startdate char(8) default NULL,
  counter int(12) default NULL
) ;

# --------------------------------------------------------

#
# Table structure for table 'counter_history'
#

DROP TABLE IF EXISTS counter_history;
CREATE TABLE counter_history (
  startdate char(8) not NULL,
  counter int(12) default NULL,
  session_counter int(12) default NULL,
  PRIMARY KEY  (startdate)
) ;

# --------------------------------------------------------

#
# Table structure for table 'countries'
#

DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
  countries_id int(11) NOT NULL auto_increment,
  countries_name varchar(64) NOT NULL default '',
  countries_iso_code_2 char(2) NOT NULL default '',
  countries_iso_code_3 char(3) NOT NULL default '',
  address_format_id int(11) NOT NULL default '0',
  PRIMARY KEY  (countries_id),
  KEY idx_countries_name_zen (countries_name),
  KEY idx_address_format_id_zen (address_format_id),
  KEY idx_iso_2_zen (countries_iso_code_2),
  KEY idx_iso_3_zen (countries_iso_code_3)
) ;

# --------------------------------------------------------

#
# Table structure for table 'coupon_email_track'
#

DROP TABLE IF EXISTS coupon_email_track;
CREATE TABLE coupon_email_track (
  unique_id int(11) NOT NULL auto_increment,
  coupon_id int(11) NOT NULL default '0',
  customer_id_sent int(11) NOT NULL default '0',
  sent_firstname varchar(32) default NULL,
  sent_lastname varchar(32) default NULL,
  emailed_to varchar(32) default NULL,
  date_sent datetime NOT NULL default '1000-01-01 00:00:00',
  PRIMARY KEY  (unique_id),
  KEY idx_coupon_id_zen (coupon_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'coupon_gv_customer'
#

DROP TABLE IF EXISTS coupon_gv_customer;
CREATE TABLE coupon_gv_customer (
  customer_id int(5) NOT NULL default '0',
  amount decimal(15,4) NOT NULL default '0.0000',
  PRIMARY KEY  (customer_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'coupon_gv_queue'
#

DROP TABLE IF EXISTS coupon_gv_queue;
CREATE TABLE coupon_gv_queue (
  unique_id int(5) NOT NULL auto_increment,
  customer_id int(5) NOT NULL default '0',
  order_id int(5) NOT NULL default '0',
  amount decimal(15,4) NOT NULL default '0.0000',
  date_created datetime NOT NULL default '1000-01-01 00:00:00',
  ipaddr varchar(32) NOT NULL default '',
  release_flag char(1) NOT NULL default 'N',
  PRIMARY KEY  (unique_id),
  KEY idx_cust_id_order_id_zen (customer_id,order_id),
  KEY idx_release_flag_zen (release_flag)
) ;

# --------------------------------------------------------

#
# Table structure for table 'coupon_redeem_track'
#

DROP TABLE IF EXISTS coupon_redeem_track;
CREATE TABLE coupon_redeem_track (
  unique_id int(11) NOT NULL auto_increment,
  coupon_id int(11) NOT NULL default '0',
  customer_id int(11) NOT NULL default '0',
  redeem_date datetime NOT NULL default '1000-01-01 00:00:00',
  redeem_ip varchar(32) NOT NULL default '',
  order_id int(11) NOT NULL default '0',
  PRIMARY KEY  (unique_id),
  KEY idx_coupon_id_zen (coupon_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'coupon_restrict'
#

DROP TABLE IF EXISTS coupon_restrict;
CREATE TABLE coupon_restrict (
  restrict_id int(11) NOT NULL auto_increment,
  coupon_id int(11) NOT NULL default '0',
  product_id int(11) NOT NULL default '0',
  category_id int(11) NOT NULL default '0',
  coupon_restrict char(1) NOT NULL default 'N',
  PRIMARY KEY  (restrict_id),
  KEY idx_coup_id_prod_id_zen (coupon_id,product_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'coupons'
#

DROP TABLE IF EXISTS coupons;
CREATE TABLE coupons (
  coupon_id int(11) NOT NULL auto_increment,
  coupon_type char(1) NOT NULL default 'F',
  coupon_code varchar(32) NOT NULL default '',
  coupon_amount decimal(15,4) NOT NULL default '0.0000',
  coupon_minimum_order decimal(15,4) NOT NULL default '0.0000',
  coupon_start_date datetime NOT NULL default '1000-01-01 00:00:00',
  coupon_expire_date datetime NOT NULL default '1000-01-01 00:00:00',
  uses_per_coupon int(5) NOT NULL default '1',
  uses_per_user int(5) NOT NULL default '0',
  restrict_to_products varchar(255) default NULL,
  restrict_to_categories varchar(255) default NULL,
  restrict_to_customers text,
  coupon_active char(1) NOT NULL default 'Y',
  date_created datetime NOT NULL default '1000-01-01 00:00:00',
  date_modified datetime NOT NULL default '1000-01-01 00:00:00',
  coupon_zone_restriction int(11) NOT NULL default '0',
  PRIMARY KEY (coupon_id),
  KEY idx_active_type_zen (coupon_active,coupon_type),
  KEY idx_coupon_code_zen (coupon_code),
  KEY idx_coupon_type_zen (coupon_type)
) ;

# --------------------------------------------------------

#
# Table structure for table 'coupons_description'
#

DROP TABLE IF EXISTS coupons_description;
CREATE TABLE coupons_description (
  coupon_id int(11) NOT NULL default '0',
  language_id int(11) NOT NULL default '0',
  coupon_name varchar(32) NOT NULL default '',
  coupon_description text,
  PRIMARY KEY (coupon_id,language_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'currencies'
#

DROP TABLE IF EXISTS currencies;
CREATE TABLE currencies (
  currencies_id int(11) NOT NULL auto_increment,
  title varchar(32) NOT NULL default '',
  code char(3) NOT NULL default '',
  symbol_left varchar(24) default NULL,
  symbol_right varchar(24) default NULL,
  decimal_point char(1) default NULL,
  thousands_point char(1) default NULL,
  decimal_places char(1) default NULL,
  value float(13,8) default NULL,
  last_updated datetime default NULL,
  PRIMARY KEY  (currencies_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'customers'
#

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  customers_id int(11) NOT NULL auto_increment,
  customers_gender char(1) NOT NULL default '',
  customers_firstname varchar(32) NOT NULL default '',
  customers_lastname varchar(32) NOT NULL default '',
  customers_dob datetime NOT NULL default '1000-01-01 00:00:00',
  customers_email_address varchar(96) NOT NULL default '',
  customers_nick varchar(96) NOT NULL default '',
  customers_default_address_id int(11) NOT NULL default '0',
  customers_telephone varchar(32) NOT NULL default '',
  customers_fax varchar(32) default NULL,
  customers_password varchar(40) NOT NULL default '',
  customers_newsletter char(1) default NULL,
  customers_group_pricing int(11) NOT NULL default '0',
  customers_email_format varchar(4) NOT NULL default 'TEXT',
  customers_authorization int(1) NOT NULL default '0',
  customers_referral varchar(32) NOT NULL default '',
  customers_paypal_payerid VARCHAR(20) NOT NULL default '',
  customers_paypal_ec TINYINT(1) UNSIGNED DEFAULT 0 NOT NULL,
  PRIMARY KEY  (customers_id),
  KEY idx_email_address_zen (customers_email_address),
  KEY idx_referral_zen (customers_referral(10)),
  KEY idx_grp_pricing_zen (customers_group_pricing),
  KEY idx_nick_zen (customers_nick),
  KEY idx_newsletter_zen (customers_newsletter)
) ;

# --------------------------------------------------------

#
# Table structure for table 'customers_basket'
#

DROP TABLE IF EXISTS customers_basket;
CREATE TABLE customers_basket (
  customers_basket_id int(11) NOT NULL auto_increment,
  customers_id int(11) NOT NULL default '0',
  products_id tinytext NOT NULL,
  customers_basket_quantity float NOT NULL default '0',
  final_price decimal(15,4) NOT NULL default '0.0000',
  customers_basket_date_added varchar(8) default NULL,
  PRIMARY KEY  (customers_basket_id),
  KEY idx_customers_id_zen (customers_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'customers_basket_attributes'
#

DROP TABLE IF EXISTS customers_basket_attributes;
CREATE TABLE customers_basket_attributes (
  customers_basket_attributes_id int(11) NOT NULL auto_increment,
  customers_id int(11) NOT NULL default '0',
  products_id tinytext NOT NULL,
  products_options_id varchar(64) NOT NULL default '0',
  products_options_value_id int(11) NOT NULL default '0',
  products_options_value_text BLOB NULL,
  products_options_sort_order text NOT NULL,
  PRIMARY KEY  (customers_basket_attributes_id),
  KEY idx_cust_id_prod_id_zen (customers_id,products_id(36))
) ;

# --------------------------------------------------------

#
# Table structure for table 'customers_info'
#

DROP TABLE IF EXISTS customers_info;
CREATE TABLE customers_info (
  customers_info_id int(11) NOT NULL default '0',
  customers_info_date_of_last_logon datetime default NULL,
  customers_info_number_of_logons int(5) default NULL,
  customers_info_date_account_created datetime default NULL,
  customers_info_date_account_last_modified datetime default NULL,
  global_product_notifications int(1) default '0',
  PRIMARY KEY  (customers_info_id)
) ;

# --------------------------------------------------------

#
# Table structure for table db_cache
#
DROP TABLE IF EXISTS db_cache;
CREATE TABLE db_cache (
  cache_entry_name varchar(64) NOT NULL default '',
  cache_data mediumblob,
  cache_entry_created int(15) default NULL,
  PRIMARY KEY  (cache_entry_name)
) ;



# --------------------------------------------------------

#
# Table structure for table 'email_archive'
#

DROP TABLE IF EXISTS email_archive;
CREATE TABLE email_archive (
  archive_id int(11) NOT NULL auto_increment,
  email_to_name varchar(96) NOT NULL default '',
  email_to_address varchar(96) NOT NULL default '',
  email_from_name varchar(96) NOT NULL default '',
  email_from_address varchar(96) NOT NULL default '',
  email_subject varchar(255) NOT NULL default '',
  email_html text NOT NULL,
  email_text text NOT NULL,
  date_sent datetime NOT NULL default '1000-01-01 00:00:00',
  module varchar(64) NOT NULL default '',
  PRIMARY KEY  (archive_id),
  KEY idx_email_to_address_zen (email_to_address),
  KEY idx_module_zen (module)
) ;


# --------------------------------------------------------

#
# Table structure for table 'ezpages'
#

DROP TABLE IF EXISTS ezpages;
CREATE TABLE ezpages (
  pages_id int(11) NOT NULL auto_increment,
  languages_id int(11) NOT NULL default '1',
  pages_title varchar(64) NOT NULL default '',
  alt_url varchar(255) NOT NULL default '',
  alt_url_external varchar(255) NOT NULL default '',
  pages_html_text mediumtext,
  status_header int(1) NOT NULL default '1',
  status_sidebox int(1) NOT NULL default '1',
  status_footer int(1) NOT NULL default '1',
  status_toc int(1) NOT NULL default '1',
  header_sort_order int(3) NOT NULL default '0',
  sidebox_sort_order int(3) NOT NULL default '0',
  footer_sort_order int(3) NOT NULL default '0',
  toc_sort_order int(3) NOT NULL default '0',
  page_open_new_window int(1) NOT NULL default '0',
  page_is_ssl int(1) NOT NULL default '0',
  toc_chapter int(11) NOT NULL default '0',
  PRIMARY KEY  (pages_id),
  KEY idx_lang_id_zen (languages_id),
  KEY idx_ezp_status_header_zen (status_header),
  KEY idx_ezp_status_sidebox_zen (status_sidebox),
  KEY idx_ezp_status_footer_zen (status_footer),
  KEY idx_ezp_status_toc_zen (status_toc)
) ;

# --------------------------------------------------------

#
# Table structure for table 'featured'
#

DROP TABLE IF EXISTS featured;
CREATE TABLE featured (
  featured_id int(11) NOT NULL auto_increment,
  products_id int(11) NOT NULL default '0',
  featured_date_added datetime default NULL,
  featured_last_modified datetime default NULL,
  expires_date date NOT NULL default '0001-01-01',
  date_status_change datetime default NULL,
  status int(1) NOT NULL default '1',
  featured_date_available date NOT NULL default '0001-01-01',
  PRIMARY KEY  (featured_id),
  KEY idx_status_zen (status),
  KEY idx_products_id_zen (products_id),
  KEY idx_date_avail_zen (featured_date_available),
  KEY idx_expires_date_zen (expires_date)
) ;

# --------------------------------------------------------

#
# Table structure for table 'files_uploaded'
#

DROP TABLE IF EXISTS files_uploaded;
CREATE TABLE files_uploaded (
  files_uploaded_id int(11) NOT NULL auto_increment,
  sesskey varchar(32) default NULL,
  customers_id int(11) default NULL,
  files_uploaded_name varchar(64) NOT NULL default '',
  PRIMARY KEY  (files_uploaded_id),
  KEY idx_customers_id_zen (customers_id)
)  COMMENT='Must always have either a sesskey or customers_id';

# --------------------------------------------------------

#
# Table structure for table 'geo_zones'
#

DROP TABLE IF EXISTS geo_zones;
CREATE TABLE geo_zones (
  geo_zone_id int(11) NOT NULL auto_increment,
  geo_zone_name varchar(32) NOT NULL default '',
  geo_zone_description varchar(255) NOT NULL default '',
  last_modified datetime default NULL,
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  PRIMARY KEY  (geo_zone_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'get_terms_to_filter'
#
DROP TABLE IF EXISTS get_terms_to_filter;
CREATE TABLE get_terms_to_filter (
  get_term_name varchar(255) NOT NULL default '',
  get_term_table varchar(64) NOT NULL,
  get_term_name_field varchar(64) NOT NULL,
  PRIMARY KEY  (get_term_name)
) ;

# --------------------------------------------------------

#
# Table structure for table 'group_pricing'
#

DROP TABLE IF EXISTS group_pricing;
CREATE TABLE group_pricing (
  group_id int(11) NOT NULL auto_increment,
  group_name varchar(32) NOT NULL default '',
  group_percentage decimal(5,2) NOT NULL default '0.00',
  last_modified datetime default NULL,
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  PRIMARY KEY  (group_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'languages'
#

DROP TABLE IF EXISTS languages;
CREATE TABLE languages (
  languages_id int(11) NOT NULL auto_increment,
  name varchar(32) NOT NULL default '',
  code char(2) NOT NULL default '',
  image varchar(64) default NULL,
  directory varchar(32) default NULL,
  sort_order int(3) default NULL,
  PRIMARY KEY  (languages_id),
  KEY idx_languages_name_zen (name)
) ;

# --------------------------------------------------------

#
# Table structure for table 'layout_boxes'
#

DROP TABLE IF EXISTS layout_boxes;
CREATE TABLE layout_boxes (
  layout_id int(11) NOT NULL auto_increment,
  layout_template varchar(64) NOT NULL default '',
  layout_box_name varchar(64) NOT NULL default '',
  layout_box_status tinyint(1) NOT NULL default '0',
  layout_box_location tinyint(1) NOT NULL default '0',
  layout_box_sort_order int(11) NOT NULL default '0',
  layout_box_sort_order_single int(11) NOT NULL default '0',
  layout_box_status_single tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (layout_id),
  KEY idx_name_template_zen (layout_template,layout_box_name),
  KEY idx_layout_box_status_zen (layout_box_status),
  KEY idx_layout_box_sort_order_zen (layout_box_sort_order)
) ;

# --------------------------------------------------------

#
# Table structure for table 'manufacturers'
#

DROP TABLE IF EXISTS manufacturers;
CREATE TABLE manufacturers (
  manufacturers_id int(11) NOT NULL auto_increment,
  manufacturers_name varchar(32) NOT NULL default '',
  manufacturers_image varchar(64) default NULL,
  date_added datetime default NULL,
  last_modified datetime default NULL,
  PRIMARY KEY  (manufacturers_id),
  KEY idx_mfg_name_zen (manufacturers_name)
) ;

# --------------------------------------------------------

#
# Table structure for table 'manufacturers_info'
#

DROP TABLE IF EXISTS manufacturers_info;
CREATE TABLE manufacturers_info (
  manufacturers_id int(11) NOT NULL default '0',
  languages_id int(11) NOT NULL default '0',
  manufacturers_url varchar(255) NOT NULL default '',
  url_clicked int(5) NOT NULL default '0',
  date_last_click datetime default NULL,
  PRIMARY KEY  (manufacturers_id,languages_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'media_clips'
#

DROP TABLE IF EXISTS media_clips;
CREATE TABLE media_clips (
  clip_id int(11) NOT NULL auto_increment,
  media_id int(11) NOT NULL default '0',
  clip_type smallint(6) NOT NULL default '0',
  clip_filename text NOT NULL,
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  last_modified datetime NOT NULL default '1000-01-01 00:00:00',
  PRIMARY KEY  (clip_id),
  KEY idx_media_id_zen (media_id),
  KEY idx_clip_type_zen (clip_type)
) ;

# --------------------------------------------------------

#
# Table structure for table 'media_manager'
#

DROP TABLE IF EXISTS media_manager;
CREATE TABLE media_manager (
  media_id int(11) NOT NULL auto_increment,
  media_name varchar(255) NOT NULL default '',
  last_modified datetime NOT NULL default '1000-01-01 00:00:00',
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  PRIMARY KEY  (media_id),
  KEY idx_media_name_zen (media_name)
) ;

# --------------------------------------------------------

#
# Table structure for table 'media_to_products'
#

DROP TABLE IF EXISTS media_to_products;
CREATE TABLE media_to_products (
  media_id int(11) NOT NULL default '0',
  product_id int(11) NOT NULL default '0',
  KEY idx_media_product_zen (media_id,product_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'media_types'
#

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
  type_id int(11) NOT NULL auto_increment,
  type_name varchar(64) NOT NULL default '',
  type_ext varchar(8) NOT NULL default '',
  PRIMARY KEY  (type_id),
  KEY idx_type_name_zen (type_name)
) ;

INSERT INTO media_types (type_name, type_ext) VALUES ('MP3','.mp3');

# -------------------------------------------------------

#
# Table structure for table 'meta_tags_categories_description'
#

DROP TABLE IF EXISTS meta_tags_categories_description;
CREATE TABLE meta_tags_categories_description (
  categories_id int(11) NOT NULL,
  language_id int(11) NOT NULL default '1',
  metatags_title varchar(255) NOT NULL default '',
  metatags_keywords text,
  metatags_description text,
  PRIMARY KEY  (categories_id,language_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'meta_tags_products_description'
#

DROP TABLE IF EXISTS meta_tags_products_description;
CREATE TABLE meta_tags_products_description (
  products_id int(11) NOT NULL,
  language_id int(11) NOT NULL default '1',
  metatags_title varchar(255) NOT NULL default '',
  metatags_keywords text,
  metatags_description text,
  PRIMARY KEY  (products_id,language_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'music_genre'
#

DROP TABLE IF EXISTS music_genre;
CREATE TABLE music_genre (
  music_genre_id int(11) NOT NULL auto_increment,
  music_genre_name varchar(32) NOT NULL default '',
  date_added datetime default NULL,
  last_modified datetime default NULL,
  PRIMARY KEY  (music_genre_id),
  KEY idx_music_genre_name_zen (music_genre_name)
) ;

# --------------------------------------------------------

#
# Table structure for table 'newsletters'
#

DROP TABLE IF EXISTS newsletters;
CREATE TABLE newsletters (
  newsletters_id int(11) NOT NULL auto_increment,
  title varchar(255) NOT NULL default '',
  content text NOT NULL,
  content_html text NOT NULL,
  module varchar(255) NOT NULL default '',
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  date_sent datetime default NULL,
  status int(1) default NULL,
  locked int(1) default '0',
  PRIMARY KEY  (newsletters_id)
) ;


# --------------------------------------------------------

#
# Table structure for table 'orders_status'
#

DROP TABLE IF EXISTS orders_status;
CREATE TABLE orders_status (
  orders_status_id int(11) NOT NULL default '0',
  language_id int(11) NOT NULL default '1',
  orders_status_name varchar(32) NOT NULL default '',
  PRIMARY KEY  (orders_status_id,language_id),
  KEY idx_orders_status_name_zen (orders_status_name)
) ;

# --------------------------------------------------------

#
# Table structure for table 'products'
#

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  products_id int(11) NOT NULL auto_increment,
  products_type int(11) NOT NULL default '1',
  products_quantity float NOT NULL default '0',
  products_model varchar(32) default NULL,
  products_image varchar(64) default NULL,
  products_price decimal(15,4) NOT NULL default '0.0000',
  products_virtual tinyint(1) NOT NULL default '0',
  products_date_added datetime NOT NULL default '1000-01-01 00:00:00',
  products_last_modified datetime default NULL,
  products_date_available datetime default NULL,
  products_weight float NOT NULL default '0',
  products_status tinyint(1) NOT NULL default '0',
  products_tax_class_id int(11) NOT NULL default '0',
  manufacturers_id int(11) default NULL,
  products_ordered float NOT NULL default '0',
  products_quantity_order_min float NOT NULL default '1',
  products_quantity_order_units float NOT NULL default '1',
  products_priced_by_attribute tinyint(1) NOT NULL default '0',
  product_is_free tinyint(1) NOT NULL default '0',
  product_is_call tinyint(1) NOT NULL default '0',
  products_quantity_mixed tinyint(1) NOT NULL default '0',
  product_is_always_free_shipping tinyint(1) NOT NULL default '0',
  products_qty_box_status tinyint(1) NOT NULL default '1',
  products_quantity_order_max float NOT NULL default '0',
  products_sort_order int(11) NOT NULL default '0',
  products_discount_type tinyint(1) NOT NULL default '0',
  products_discount_type_from tinyint(1) NOT NULL default '0',
  products_price_sorter decimal(15,4) NOT NULL default '0.0000',
  master_categories_id int(11) NOT NULL default '0',
  products_mixed_discount_quantity tinyint(1) NOT NULL default '1',
  metatags_title_status tinyint(1) NOT NULL default '0',
  metatags_products_name_status tinyint(1) NOT NULL default '0',
  metatags_model_status tinyint(1) NOT NULL default '0',
  metatags_price_status tinyint(1) NOT NULL default '0',
  metatags_title_tagline_status tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (products_id),
  KEY idx_products_date_added_zen (products_date_added),
  KEY idx_products_status_zen (products_status),
  KEY idx_products_date_available_zen (products_date_available),
  KEY idx_products_ordered_zen (products_ordered),
  KEY idx_products_model_zen (products_model),
  KEY idx_products_price_sorter_zen (products_price_sorter),
  KEY idx_master_categories_id_zen (master_categories_id),
  KEY idx_products_sort_order_zen (products_sort_order),
  KEY idx_manufacturers_id_zen (manufacturers_id),
  foreign key (manufacturers_id) references manufacturers(manufacturers_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'orders'
#

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  orders_id int(11) NOT NULL auto_increment,
  customers_id int(11) NOT NULL default '0',
  customers_name varchar(64) NOT NULL default '',
  customers_company varchar(64) default NULL,
  customers_street_address varchar(64) NOT NULL default '',
  customers_suburb varchar(32) default NULL,
  customers_city varchar(32) NOT NULL default '',
  customers_postcode varchar(10) NOT NULL default '',
  customers_state varchar(32) default NULL,
  customers_country varchar(32) NOT NULL default '',
  customers_telephone varchar(32) NOT NULL default '',
  customers_email_address varchar(96) NOT NULL default '',
  customers_address_format_id int(5) NOT NULL default '0',
  delivery_name varchar(64) NOT NULL default '',
  delivery_company varchar(64) default NULL,
  delivery_street_address varchar(64) NOT NULL default '',
  delivery_suburb varchar(32) default NULL,
  delivery_city varchar(32) NOT NULL default '',
  delivery_postcode varchar(10) NOT NULL default '',
  delivery_state varchar(32) default NULL,
  delivery_country varchar(32) NOT NULL default '',
  delivery_address_format_id int(5) NOT NULL default '0',
  billing_name varchar(64) NOT NULL default '',
  billing_company varchar(64) default NULL,
  billing_street_address varchar(64) NOT NULL default '',
  billing_suburb varchar(32) default NULL,
  billing_city varchar(32) NOT NULL default '',
  billing_postcode varchar(10) NOT NULL default '',
  billing_state varchar(32) default NULL,
  billing_country varchar(32) NOT NULL default '',
  billing_address_format_id int(5) NOT NULL default '0',
  payment_method varchar(128) NOT NULL default '',
  payment_module_code varchar(32) NOT NULL default '',
  shipping_method varchar(128) NOT NULL default '',
  shipping_module_code varchar(32) NOT NULL default '',
  coupon_code varchar(32) NOT NULL default '',
  cc_type varchar(20) default NULL,
  cc_owner varchar(64) default NULL,
  cc_number varchar(32) default NULL,
  cc_expires varchar(4) default NULL,
  cc_cvv blob,
  last_modified datetime default NULL,
  date_purchased datetime default NULL,
  orders_status int(5) NOT NULL default '0',
  orders_date_finished datetime default NULL,
  currency char(3) default NULL,
  currency_value decimal(14,6) default NULL,
  order_total decimal(14,2) default NULL,
  order_tax decimal(14,2) default NULL,
  paypal_ipn_id int(11) NOT NULL default '0',
  ip_address varchar(96) NOT NULL default '',
  PRIMARY KEY  (orders_id),
  KEY idx_status_orders_cust_zen (orders_status,orders_id,customers_id),
  KEY idx_date_purchased_zen (date_purchased),
  KEY idx_cust_id_orders_id_zen (customers_id,orders_id),
  foreign key (customers_id) references customers(customers_id),
  foreign key (orders_status) references orders_status(orders_status_id)
) ;


# --------------------------------------------------------

#
# Table structure for table 'orders_products'
#

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  orders_products_id int(11) NOT NULL auto_increment,
  orders_id int(11) NOT NULL default '0',
  products_id int(11) NOT NULL default '0',
  products_model varchar(32) default NULL,
  products_name varchar(64) NOT NULL default '',
  products_price decimal(15,4) NOT NULL default '0.0000',
  final_price decimal(15,4) NOT NULL default '0.0000',
  products_tax decimal(7,4) NOT NULL default '0.0000',
  products_quantity float NOT NULL default '0',
  onetime_charges decimal(15,4) NOT NULL default '0.0000',
  products_priced_by_attribute tinyint(1) NOT NULL default '0',
  product_is_free tinyint(1) NOT NULL default '0',
  products_discount_type tinyint(1) NOT NULL default '0',
  products_discount_type_from tinyint(1) NOT NULL default '0',
  products_prid tinytext NOT NULL,
  PRIMARY KEY  (orders_products_id),
  KEY idx_orders_id_prod_id_zen (orders_id,products_id),
  KEY idx_prod_id_orders_id_zen (products_id,orders_id),
  foreign key (orders_id) references orders(orders_id),
  foreign key (products_id) references products(products_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'orders_products_attributes'
#

DROP TABLE IF EXISTS orders_products_attributes;
CREATE TABLE orders_products_attributes (
  orders_products_attributes_id int(11) NOT NULL auto_increment,
  orders_id int(11) NOT NULL default '0',
  orders_products_id int(11) NOT NULL default '0',
  products_options varchar(32) NOT NULL default '',
  products_options_values text NOT NULL,
  options_values_price decimal(15,4) NOT NULL default '0.0000',
  price_prefix char(1) NOT NULL default '',
  product_attribute_is_free tinyint(1) NOT NULL default '0',
  products_attributes_weight float NOT NULL default '0',
  products_attributes_weight_prefix char(1) NOT NULL default '',
  attributes_discounted tinyint(1) NOT NULL default '1',
  attributes_price_base_included tinyint(1) NOT NULL default '1',
  attributes_price_onetime decimal(15,4) NOT NULL default '0.0000',
  attributes_price_factor decimal(15,4) NOT NULL default '0.0000',
  attributes_price_factor_offset decimal(15,4) NOT NULL default '0.0000',
  attributes_price_factor_onetime decimal(15,4) NOT NULL default '0.0000',
  attributes_price_factor_onetime_offset decimal(15,4) NOT NULL default '0.0000',
  attributes_qty_prices text,
  attributes_qty_prices_onetime text,
  attributes_price_words decimal(15,4) NOT NULL default '0.0000',
  attributes_price_words_free int(4) NOT NULL default '0',
  attributes_price_letters decimal(15,4) NOT NULL default '0.0000',
  attributes_price_letters_free int(4) NOT NULL default '0',
  products_options_id int(11) NOT NULL default '0',
  products_options_values_id int(11) NOT NULL default '0',
  products_prid tinytext NOT NULL,
  PRIMARY KEY  (orders_products_attributes_id),
  KEY idx_orders_id_prod_id_zen (orders_id,orders_products_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'orders_products_download'
#

DROP TABLE IF EXISTS orders_products_download;
CREATE TABLE orders_products_download (
  orders_products_download_id int(11) NOT NULL auto_increment,
  orders_id int(11) NOT NULL default '0',
  orders_products_id int(11) NOT NULL default '0',
  orders_products_filename varchar(255) NOT NULL default '',
  download_maxdays int(2) NOT NULL default '0',
  download_count int(2) NOT NULL default '0',
  products_prid tinytext NOT NULL,
  PRIMARY KEY  (orders_products_download_id),
  KEY idx_orders_id_zen (orders_id),
  KEY idx_orders_products_id_zen (orders_products_id)
) ;



# --------------------------------------------------------

#
# Table structure for table 'orders_status_history'
#

DROP TABLE IF EXISTS orders_status_history;
CREATE TABLE orders_status_history (
  orders_status_history_id int(11) NOT NULL auto_increment,
  orders_id int(11) NOT NULL default '0',
  orders_status_id int(5) NOT NULL default '0',
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  customer_notified int(1) default '0',
  comments text,
  PRIMARY KEY  (orders_status_history_id),
  KEY idx_orders_id_status_id_zen (orders_id,orders_status_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'orders_total'
#

DROP TABLE IF EXISTS orders_total;
CREATE TABLE orders_total (
  orders_total_id int(10) unsigned NOT NULL auto_increment,
  orders_id int(11) NOT NULL default '0',
  title varchar(255) NOT NULL default '',
  text varchar(255) NOT NULL default '',
  value decimal(15,4) NOT NULL default '0.0000',
  class varchar(32) NOT NULL default '',
  sort_order int(11) NOT NULL default '0',
  PRIMARY KEY  (orders_total_id),
  KEY idx_ot_orders_id_zen (orders_id),
  KEY idx_ot_class_zen (class)
) ;

# --------------------------------------------------------

#
# Table structure for table 'paypal'
#

DROP TABLE IF EXISTS paypal;
CREATE TABLE paypal (
  paypal_ipn_id int(11) unsigned NOT NULL auto_increment,
  order_id int(11) unsigned NOT NULL default '0',
  txn_type varchar(40) NOT NULL default '',
  module_name varchar(40) NOT NULL default '',
  module_mode varchar(40) NOT NULL default '',
  reason_code varchar(40) default NULL,
  payment_type varchar(40) NOT NULL default '',
  payment_status varchar(32) NOT NULL default '',
  pending_reason varchar(32) default NULL,
  invoice varchar(128) default NULL,
  mc_currency char(3) NOT NULL default '',
  first_name varchar(32) NOT NULL default '',
  last_name varchar(32) NOT NULL default '',
  payer_business_name varchar(128) default NULL,
  address_name varchar(64) default NULL,
  address_street varchar(254) default NULL,
  address_city varchar(120) default NULL,
  address_state varchar(120) default NULL,
  address_zip varchar(10) default NULL,
  address_country varchar(64) default NULL,
  address_status varchar(11) default NULL,
  payer_email varchar(128) NOT NULL default '',
  payer_id varchar(32) NOT NULL default '',
  payer_status varchar(10) NOT NULL default '',
  payment_date datetime NOT NULL default '1000-01-01 00:00:00',
  business varchar(128) NOT NULL default '',
  receiver_email varchar(128) NOT NULL default '',
  receiver_id varchar(32) NOT NULL default '',
  txn_id varchar(20) NOT NULL default '',
  parent_txn_id varchar(20) default NULL,
  num_cart_items tinyint(4) unsigned NOT NULL default '1',
  mc_gross decimal(7,2) NOT NULL default '0.00',
  mc_fee decimal(7,2) NOT NULL default '0.00',
  payment_gross decimal(7,2) default NULL,
  payment_fee decimal(7,2) default NULL,
  settle_amount decimal(7,2) default NULL,
  settle_currency char(3) default NULL,
  exchange_rate decimal(4,2) default NULL,
  notify_version varchar(6) NOT NULL default '',
  verify_sign varchar(128) NOT NULL default '',
  last_modified datetime NOT NULL default '1000-01-01 00:00:00',
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  memo text,
  PRIMARY KEY (paypal_ipn_id,txn_id),
  KEY idx_order_id_zen (order_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'paypal_payment_status'
#

DROP TABLE IF EXISTS paypal_payment_status;
CREATE TABLE paypal_payment_status (
  payment_status_id int(11) NOT NULL auto_increment,
  payment_status_name varchar(64) NOT NULL default '',
  PRIMARY KEY (payment_status_id)
) ;

#
# Dumping data for table 'paypal_payment_status'
#

INSERT INTO paypal_payment_status VALUES (1, 'Completed');
INSERT INTO paypal_payment_status VALUES (2, 'Pending');
INSERT INTO paypal_payment_status VALUES (3, 'Failed');
INSERT INTO paypal_payment_status VALUES (4, 'Denied');
INSERT INTO paypal_payment_status VALUES (5, 'Refunded');
INSERT INTO paypal_payment_status VALUES (6, 'Canceled_Reversal');
INSERT INTO paypal_payment_status VALUES (7, 'Reversed');

# --------------------------------------------------------

#
# Table structure for table 'paypal_payment_status_history'
#

DROP TABLE IF EXISTS paypal_payment_status_history;
CREATE TABLE paypal_payment_status_history (
  payment_status_history_id int(11) NOT NULL auto_increment,
  paypal_ipn_id int(11) NOT NULL default '0',
  txn_id varchar(64) NOT NULL default '',
  parent_txn_id varchar(64) NOT NULL default '',
  payment_status varchar(17) NOT NULL default '',
  pending_reason varchar(14) default NULL,
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  PRIMARY KEY (payment_status_history_id),
  KEY idx_paypal_ipn_id_zen (paypal_ipn_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'paypal_session'
#

DROP TABLE IF EXISTS paypal_session;
CREATE TABLE paypal_session (
  unique_id int(11) NOT NULL auto_increment,
  session_id text NOT NULL,
  saved_session mediumblob NOT NULL,
  expiry int(17) NOT NULL default '0',
  PRIMARY KEY  (unique_id),
  KEY idx_session_id_zen (session_id(36))
) ;

# --------------------------------------------------------

#
# Table structure for table 'paypal_testing'
#

DROP TABLE IF EXISTS paypal_testing;
CREATE TABLE paypal_testing (
  paypal_ipn_id int(11) unsigned NOT NULL auto_increment,
  order_id int(11) unsigned NOT NULL default '0',
  custom varchar(255) NOT NULL default '',
  txn_type varchar(40) NOT NULL default '',
  module_name varchar(40) NOT NULL default '',
  module_mode varchar(40) NOT NULL default '',
  reason_code varchar(40) default NULL,
  payment_type varchar(40) NOT NULL default '',
  payment_status varchar(32) NOT NULL default '',
  pending_reason varchar(32) default NULL,
  invoice varchar(128) default NULL,
  mc_currency char(3) NOT NULL default '',
  first_name varchar(32) NOT NULL default '',
  last_name varchar(32) NOT NULL default '',
  payer_business_name varchar(128) default NULL,
  address_name varchar(64) default NULL,
  address_street varchar(254) default NULL,
  address_city varchar(120) default NULL,
  address_state varchar(120) default NULL,
  address_zip varchar(10) default NULL,
  address_country varchar(64) default NULL,
  address_status varchar(11) default NULL,
  payer_email varchar(128) NOT NULL default '',
  payer_id varchar(32) NOT NULL default '',
  payer_status varchar(10) NOT NULL default '',
  payment_date datetime NOT NULL default '1000-01-01 00:00:00',
  business varchar(128) NOT NULL default '',
  receiver_email varchar(128) NOT NULL default '',
  receiver_id varchar(32) NOT NULL default '',
  txn_id varchar(20) NOT NULL default '',
  parent_txn_id varchar(20) default NULL,
  num_cart_items tinyint(4) unsigned NOT NULL default '1',
  mc_gross decimal(7,2) NOT NULL default '0.00',
  mc_fee decimal(7,2) NOT NULL default '0.00',
  payment_gross decimal(7,2) default NULL,
  payment_fee decimal(7,2) default NULL,
  settle_amount decimal(7,2) default NULL,
  settle_currency char(3) default NULL,
  exchange_rate decimal(4,2) default NULL,
  notify_version decimal(2,1) NOT NULL default '0.0',
  verify_sign varchar(128) NOT NULL default '',
  last_modified datetime NOT NULL default '1000-01-01 00:00:00',
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  memo text,
  PRIMARY KEY  (paypal_ipn_id,txn_id),
  KEY idx_order_id_zen (order_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'product_music_extra'
#

DROP TABLE IF EXISTS product_music_extra;
CREATE TABLE product_music_extra (
  products_id int(11) NOT NULL default '0',
  artists_id int(11) NOT NULL default '0',
  record_company_id int(11) NOT NULL default '0',
  music_genre_id int(11) NOT NULL default '0',
  PRIMARY KEY  (products_id),
  KEY idx_music_genre_id_zen (music_genre_id),
  KEY idx_artists_id_zen (artists_id),
  KEY idx_record_company_id_zen (record_company_id)
) ;


# --------------------------------------------------------

#
# Table structure for table 'product_type_layout'
#
DROP TABLE IF EXISTS product_type_layout;
CREATE TABLE product_type_layout (
  configuration_id int(11) NOT NULL auto_increment,
  configuration_title text NOT NULL,
  configuration_key varchar(255) NOT NULL default '',
  configuration_value text NOT NULL,
  configuration_description text NOT NULL,
  product_type_id int(11) NOT NULL default '0',
  sort_order int(5) default NULL,
  last_modified datetime default NULL,
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  use_function text default NULL,
  set_function text default NULL,
  PRIMARY KEY  (configuration_id),
  UNIQUE KEY unq_config_key_zen (configuration_key),
  KEY idx_key_value_zen (configuration_key,configuration_value(10)),
  KEY idx_type_id_sort_order_zen (product_type_id,sort_order)
) ;

# --------------------------------------------------------

#
# Table structure for table 'product_types'
#

DROP TABLE IF EXISTS product_types;
CREATE TABLE product_types (
  type_id int(11) NOT NULL auto_increment,
  type_name varchar(255) NOT NULL default '',
  type_handler varchar(255) NOT NULL default '',
  type_master_type int(11) NOT NULL default '1',
  allow_add_to_cart char(1) NOT NULL default 'Y',
  default_image varchar(255) NOT NULL default '',
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  last_modified datetime NOT NULL default '1000-01-01 00:00:00',
  PRIMARY KEY  (type_id),
  KEY idx_type_master_type_zen (type_master_type)
) ;

# --------------------------------------------------------

#
# Table structure for table 'product_types_to_category'
#

DROP TABLE IF EXISTS product_types_to_category;
CREATE TABLE product_types_to_category (
  product_type_id int(11) NOT NULL default '0',
  category_id int(11) NOT NULL default '0',
  KEY idx_category_id_zen (category_id),
  KEY idx_product_type_id_zen (product_type_id)
) ;



# --------------------------------------------------------

#
# Table structure for table 'products_attributes'
#

DROP TABLE IF EXISTS products_attributes;
CREATE TABLE products_attributes (
  products_attributes_id int(11) NOT NULL auto_increment,
  products_id int(11) NOT NULL default '0',
  options_id int(11) NOT NULL default '0',
  options_values_id int(11) NOT NULL default '0',
  options_values_price decimal(15,4) NOT NULL default '0.0000',
  price_prefix char(1) NOT NULL default '',
  products_options_sort_order int(11) NOT NULL default '0',
  product_attribute_is_free tinyint(1) NOT NULL default '0',
  products_attributes_weight float NOT NULL default '0',
  products_attributes_weight_prefix char(1) NOT NULL default '',
  attributes_display_only tinyint(1) NOT NULL default '0',
  attributes_default tinyint(1) NOT NULL default '0',
  attributes_discounted tinyint(1) NOT NULL default '1',
  attributes_image varchar(64) default NULL,
  attributes_price_base_included tinyint(1) NOT NULL default '1',
  attributes_price_onetime decimal(15,4) NOT NULL default '0.0000',
  attributes_price_factor decimal(15,4) NOT NULL default '0.0000',
  attributes_price_factor_offset decimal(15,4) NOT NULL default '0.0000',
  attributes_price_factor_onetime decimal(15,4) NOT NULL default '0.0000',
  attributes_price_factor_onetime_offset decimal(15,4) NOT NULL default '0.0000',
  attributes_qty_prices text,
  attributes_qty_prices_onetime text,
  attributes_price_words decimal(15,4) NOT NULL default '0.0000',
  attributes_price_words_free int(4) NOT NULL default '0',
  attributes_price_letters decimal(15,4) NOT NULL default '0.0000',
  attributes_price_letters_free int(4) NOT NULL default '0',
  attributes_required tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (products_attributes_id),
  KEY idx_id_options_id_values_zen (products_id,options_id,options_values_id),
  KEY idx_opt_sort_order_zen (products_options_sort_order),
  foreign key (products_id) references products(products_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'products_attributes_download'
#

DROP TABLE IF EXISTS products_attributes_download;
CREATE TABLE products_attributes_download (
  products_attributes_id int(11) NOT NULL default '0',
  products_attributes_filename varchar(255) NOT NULL default '',
  products_attributes_maxdays int(2) default '0',
  products_attributes_maxcount int(2) default '0',
  PRIMARY KEY  (products_attributes_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'products_description'
#

DROP TABLE IF EXISTS products_description;
CREATE TABLE products_description (
  products_id int(11) NOT NULL auto_increment,
  language_id int(11) NOT NULL default '1',
  products_name varchar(64) NOT NULL default '',
  products_description text,
  products_url varchar(255) default NULL,
  products_viewed int(5) default '0',
  PRIMARY KEY  (products_id,language_id),
  KEY idx_products_name_zen (products_name),
  foreign key (products_id) references products(products_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'products_discount_quantity'
#
DROP TABLE IF EXISTS products_discount_quantity;
CREATE TABLE products_discount_quantity (
  discount_id int(4) NOT NULL default '0',
  products_id int(11) NOT NULL default '0',
  discount_qty float NOT NULL default '0',
  discount_price decimal(15,4) NOT NULL default '0.0000',
  KEY idx_id_qty_zen (products_id,discount_qty)
) ;

# --------------------------------------------------------

#
# Table structure for table 'products_notifications'
#

DROP TABLE IF EXISTS products_notifications;
CREATE TABLE products_notifications (
  products_id int(11) NOT NULL default '0',
  customers_id int(11) NOT NULL default '0',
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  PRIMARY KEY  (products_id,customers_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'products_options'
#

DROP TABLE IF EXISTS products_options;
CREATE TABLE products_options (
  products_options_id int(11) NOT NULL default '0',
  language_id int(11) NOT NULL default '1',
  products_options_name varchar(32) NOT NULL default '',
  products_options_sort_order int(11) NOT NULL default '0',
  products_options_type int(5) NOT NULL default '0',
  products_options_length smallint(2) NOT NULL default '32',
  products_options_comment varchar(64) default NULL,
  products_options_size smallint(2) NOT NULL default '32',
  products_options_images_per_row int(2) default '5',
  products_options_images_style int(1) default '0',
  products_options_rows smallint(2) NOT NULL default '1',
  PRIMARY KEY  (products_options_id,language_id),
  KEY idx_lang_id_zen (language_id),
  KEY idx_products_options_sort_order_zen (products_options_sort_order),
  KEY idx_products_options_name_zen (products_options_name)
) ;

# --------------------------------------------------------

#
# Table structure for table 'products_options_types'
#

DROP TABLE IF EXISTS products_options_types;
CREATE TABLE products_options_types (
  products_options_types_id int(11) NOT NULL default '0',
  products_options_types_name varchar(32) default NULL,
  PRIMARY KEY  (products_options_types_id)
)  COMMENT='Track products_options_types';

# --------------------------------------------------------

#
# Table structure for table 'products_options_values'
#

DROP TABLE IF EXISTS products_options_values;
CREATE TABLE products_options_values (
  products_options_values_id int(11) NOT NULL default '0',
  language_id int(11) NOT NULL default '1',
  products_options_values_name varchar(64) NOT NULL default '',
  products_options_values_sort_order int(11) NOT NULL default '0',
  PRIMARY KEY (products_options_values_id,language_id),
  KEY idx_products_options_values_name_zen (products_options_values_name),
  KEY idx_products_options_values_sort_order_zen (products_options_values_sort_order)
) ;

# --------------------------------------------------------

#
# Table structure for table 'products_options_values_to_products_options'
#

DROP TABLE IF EXISTS products_options_values_to_products_options;
CREATE TABLE products_options_values_to_products_options (
  products_options_values_to_products_options_id int(11) NOT NULL auto_increment,
  products_options_id int(11) NOT NULL default '0',
  products_options_values_id int(11) NOT NULL default '0',
  PRIMARY KEY  (products_options_values_to_products_options_id),
  KEY idx_products_options_id_zen (products_options_id),
  KEY idx_products_options_values_id_zen (products_options_values_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'products_to_categories'
#

DROP TABLE IF EXISTS products_to_categories;
CREATE TABLE products_to_categories (
  products_id int(11) NOT NULL default '0',
  categories_id int(11) NOT NULL default '0',
  PRIMARY KEY  (products_id,categories_id),
  KEY idx_cat_prod_id_zen (categories_id,products_id),
  foreign key (products_id) references products(products_id),
  foreign key (categories_id) references categories(categories_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'project_version'
#

DROP TABLE IF EXISTS project_version;
CREATE TABLE project_version (
  project_version_id tinyint(3) NOT NULL auto_increment,
  project_version_key varchar(40) NOT NULL default '',
  project_version_major varchar(20) NOT NULL default '',
  project_version_minor varchar(20) NOT NULL default '',
  project_version_patch1 varchar(20) NOT NULL default '',
  project_version_patch2 varchar(20) NOT NULL default '',
  project_version_patch1_source varchar(20) NOT NULL default '',
  project_version_patch2_source varchar(20) NOT NULL default '',
  project_version_comment varchar(250) NOT NULL default '',
  project_version_date_applied datetime NOT NULL default '0001-01-01 01:01:01',
  PRIMARY KEY  (project_version_id),
  UNIQUE KEY idx_project_version_key_zen (project_version_key)
)  COMMENT='Database Version Tracking';


# --------------------------------------------------------

#
# Table structure for table 'project_version_history'
#
DROP TABLE IF EXISTS project_version_history;
CREATE TABLE project_version_history (
  project_version_id tinyint(3) NOT NULL auto_increment,
  project_version_key varchar(40) NOT NULL default '',
  project_version_major varchar(20) NOT NULL default '',
  project_version_minor varchar(20) NOT NULL default '',
  project_version_patch varchar(20) NOT NULL default '',
  project_version_comment varchar(250) NOT NULL default '',
  project_version_date_applied datetime NOT NULL default '0001-01-01 01:01:01',
  PRIMARY KEY  (project_version_id)
)  COMMENT='Database Version Tracking History';

# --------------------------------------------------------

#
# Table structure for table 'query_builder'
# This table is used by audiences.php for building data-extraction queries
#
DROP TABLE IF EXISTS query_builder;
CREATE TABLE query_builder (
  query_id int(11) NOT NULL auto_increment,
  query_category varchar(40) NOT NULL default '',
  query_name varchar(80) NOT NULL default '',
  query_description TEXT NOT NULL,
  query_string TEXT NOT NULL,
  query_keys_list TEXT NOT NULL,
  PRIMARY KEY  (query_id),
  UNIQUE KEY query_name (query_name)
)  COMMENT='Stores queries for re-use in Admin email and report modules';

# --------------------------------------------------------

#
# Table structure for table 'record_artists'
#

DROP TABLE IF EXISTS record_artists;
CREATE TABLE record_artists (
  artists_id int(11) NOT NULL auto_increment,
  artists_name varchar(32) NOT NULL default '',
  artists_image varchar(64) default NULL,
  date_added datetime default NULL,
  last_modified datetime default NULL,
  PRIMARY KEY  (artists_id),
  KEY idx_rec_artists_name_zen (artists_name)
) ;

# --------------------------------------------------------

#
# Table structure for table 'record_artists_info'
#

DROP TABLE IF EXISTS record_artists_info;
CREATE TABLE record_artists_info (
  artists_id int(11) NOT NULL default '0',
  languages_id int(11) NOT NULL default '0',
  artists_url varchar(255) NOT NULL default '',
  url_clicked int(5) NOT NULL default '0',
  date_last_click datetime default NULL,
  PRIMARY KEY  (artists_id,languages_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'record_company'
#

DROP TABLE IF EXISTS record_company;
CREATE TABLE record_company (
  record_company_id int(11) NOT NULL auto_increment,
  record_company_name varchar(32) NOT NULL default '',
  record_company_image varchar(64) default NULL,
  date_added datetime default NULL,
  last_modified datetime default NULL,
  PRIMARY KEY  (record_company_id),
  KEY idx_rec_company_name_zen (record_company_name)
) ;

# --------------------------------------------------------

#
# Table structure for table 'record_company_info'
#

DROP TABLE IF EXISTS record_company_info;
CREATE TABLE record_company_info (
  record_company_id int(11) NOT NULL default '0',
  languages_id int(11) NOT NULL default '0',
  record_company_url varchar(255) NOT NULL default '',
  url_clicked int(5) NOT NULL default '0',
  date_last_click datetime default NULL,
  PRIMARY KEY  (record_company_id,languages_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'reviews'
#

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
  reviews_id int(11) NOT NULL auto_increment,
  products_id int(11) NOT NULL default '0',
  customers_id int(11) default NULL,
  customers_name varchar(64) NOT NULL default '',
  reviews_rating int(1) default NULL,
  date_added datetime default NULL,
  last_modified datetime default NULL,
  reviews_read int(5) NOT NULL default '0',
  status int(1) NOT NULL default '1',
  PRIMARY KEY  (reviews_id),
  KEY idx_products_id_zen (products_id),
  KEY idx_customers_id_zen (customers_id),
  KEY idx_status_zen (status),
  KEY idx_date_added_zen (date_added),
  foreign key (products_id) references products(products_id),
  foreign key (customers_id) references customers(customers_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'reviews_description'
#

DROP TABLE IF EXISTS reviews_description;
CREATE TABLE reviews_description (
  reviews_id int(11) NOT NULL default '0',
  languages_id int(11) NOT NULL default '0',
  reviews_text text NOT NULL,
  PRIMARY KEY  (reviews_id,languages_id),
  foreign key (reviews_id) references reviews(reviews_id),
  foreign key (languages_id) references languages(languages_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'salemaker_sales'
#

DROP TABLE IF EXISTS salemaker_sales;
CREATE TABLE salemaker_sales (
  sale_id int(11) NOT NULL auto_increment,
  sale_status tinyint(4) NOT NULL default '0',
  sale_name varchar(30) NOT NULL default '',
  sale_deduction_value decimal(15,4) NOT NULL default '0.0000',
  sale_deduction_type tinyint(4) NOT NULL default '0',
  sale_pricerange_from decimal(15,4) NOT NULL default '0.0000',
  sale_pricerange_to decimal(15,4) NOT NULL default '0.0000',
  sale_specials_condition tinyint(4) NOT NULL default '0',
  sale_categories_selected text,
  sale_categories_all text,
  sale_date_start date NOT NULL default '0001-01-01',
  sale_date_end date NOT NULL default '0001-01-01',
  sale_date_added date NOT NULL default '0001-01-01',
  sale_date_last_modified date NOT NULL default '0001-01-01',
  sale_date_status_change date NOT NULL default '0001-01-01',
  PRIMARY KEY  (sale_id),
  KEY idx_sale_status_zen (sale_status),
  KEY idx_sale_date_start_zen (sale_date_start),
  KEY idx_sale_date_end_zen (sale_date_end)
) ;

# --------------------------------------------------------

#
# Table structure for table 'sessions'
#

DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions (
  sesskey varchar(64) NOT NULL default '',
  expiry int(11) unsigned NOT NULL default '0',
  value mediumblob NOT NULL,
  PRIMARY KEY  (sesskey)
) ;

# --------------------------------------------------------

#
# Table structure for table 'specials'
#

DROP TABLE IF EXISTS specials;
CREATE TABLE specials (
  specials_id int(11) NOT NULL auto_increment,
  products_id int(11) NOT NULL default '0',
  specials_new_products_price decimal(15,4) NOT NULL default '0.0000',
  specials_date_added datetime default NULL,
  specials_last_modified datetime default NULL,
  expires_date date NOT NULL default '0001-01-01',
  date_status_change datetime default NULL,
  status int(1) NOT NULL default '1',
  specials_date_available date NOT NULL default '0001-01-01',
  PRIMARY KEY  (specials_id),
  KEY idx_status_zen (status),
  KEY idx_products_id_zen (products_id),
  KEY idx_date_avail_zen (specials_date_available),
  KEY idx_expires_date_zen (expires_date)
) ;

# --------------------------------------------------------

#
# Table structure for table 'tax_class'
#

DROP TABLE IF EXISTS tax_class;
CREATE TABLE tax_class (
  tax_class_id int(11) NOT NULL auto_increment,
  tax_class_title varchar(32) NOT NULL default '',
  tax_class_description varchar(255) NOT NULL default '',
  last_modified datetime default NULL,
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  PRIMARY KEY  (tax_class_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'tax_rates'
#

DROP TABLE IF EXISTS tax_rates;
CREATE TABLE tax_rates (
  tax_rates_id int(11) NOT NULL auto_increment,
  tax_zone_id int(11) NOT NULL default '0',
  tax_class_id int(11) NOT NULL default '0',
  tax_priority int(5) default '1',
  tax_rate decimal(7,4) NOT NULL default '0.0000',
  tax_description varchar(255) NOT NULL default '',
  last_modified datetime default NULL,
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  PRIMARY KEY  (tax_rates_id),
  KEY idx_tax_zone_id_zen (tax_zone_id),
  KEY idx_tax_class_id_zen (tax_class_id)
) ;

# --------------------------------------------------------

#
# Table structure for table 'template_select'
#

DROP TABLE IF EXISTS template_select;
CREATE TABLE template_select (
  template_id int(11) NOT NULL auto_increment,
  template_dir varchar(64) NOT NULL default '',
  template_language varchar(64) NOT NULL default '0',
  PRIMARY KEY  (template_id),
  KEY idx_tpl_lang_zen (template_language)
) ;

# --------------------------------------------------------


#
# Table structure for table 'whos_online'
#

DROP TABLE IF EXISTS whos_online;
CREATE TABLE whos_online (
  customer_id int(11) default NULL,
  full_name varchar(64) NOT NULL default '',
  session_id varchar(128) NOT NULL default '',
  ip_address varchar(20) NOT NULL default '',
  time_entry varchar(14) NOT NULL default '',
  time_last_click varchar(14) NOT NULL default '',
  last_page_url varchar(255) NOT NULL default '',
  host_address text NOT NULL,
  user_agent varchar(255) NOT NULL default '',
  KEY idx_ip_address_zen (ip_address),
  KEY idx_session_id_zen (session_id),
  KEY idx_customer_id_zen (customer_id),
  KEY idx_time_entry_zen (time_entry),
  KEY idx_time_last_click_zen (time_last_click),
  KEY idx_last_page_url_zen (last_page_url)
) ;

# --------------------------------------------------------

#
# Table structure for table 'zones'
#

DROP TABLE IF EXISTS zones;
CREATE TABLE zones (
  zone_id int(11) NOT NULL auto_increment,
  zone_country_id int(11) NOT NULL default '0',
  zone_code varchar(32) NOT NULL default '',
  zone_name varchar(32) NOT NULL default '',
  PRIMARY KEY  (zone_id),
  KEY idx_zone_country_id_zen (zone_country_id),
  KEY idx_zone_code_zen (zone_code)
) ;

# --------------------------------------------------------

#
# Table structure for table 'zones_to_geo_zones'
#

DROP TABLE IF EXISTS zones_to_geo_zones;
CREATE TABLE zones_to_geo_zones (
  association_id int(11) NOT NULL auto_increment,
  zone_country_id int(11) NOT NULL default '0',
  zone_id int(11) default NULL,
  geo_zone_id int(11) default NULL,
  last_modified datetime default NULL,
  date_added datetime NOT NULL default '1000-01-01 00:00:00',
  PRIMARY KEY  (association_id),
  KEY idx_zones_zen (geo_zone_id,zone_country_id,zone_id)
) ;




-- E1NGINE=MyISAM












