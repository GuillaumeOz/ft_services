<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', null);

/** MySQL database username */
define('DB_USER', null);

/** MySQL database password */
define('DB_PASSWORD', null);

/** MySQL hostname */
define('DB_HOST', null);

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'oS;5{ bZXTR}hJ|(N{~W}+|yQs&|`:5>.G$dpMG4NBb5$VP4Zq=_snVx_FmmU!Gj');
define('SECURE_AUTH_KEY',  'x>pfi6]-&U]f4uGQ_;aq}Vei=+7zu x2IulRL^TfJdBL?4>7,t1#uuOPH<*L;R^o');
define('LOGGED_IN_KEY',    'zy Fjl|rX-jsd1`_H*>Q,~IbLJZ-oNcAjg<4(yE_?VNN<IiB_EW$`;r]@15os@Z=');
define('NONCE_KEY',        ')G1X&M(>[epNG}|c?3hI6M&A&PLK$?S?gKivgO,C9+L?|a1Ws=#<F ;2}/zbR&_{');
define('AUTH_SALT',        '.No 1feSYLt,pea)n&/*d)zeYk?$*TB?;*}![dMk*|0W6Xd(<PJCZ-!Fh0Imh}wD');
define('SECURE_AUTH_SALT', '7}Z~0t&v9*tQ6%z-oT&Cmj[4|i)(v+{reA<Id+hQd@0l_UM%e+j34=k>b2[ubLHQ');
define('LOGGED_IN_SALT',   '[48|DH{-=RtU)->a6YJQ}~mTZ0LJ,gfP]{Dk;]85,]aW-up~8`x742V.SJr#{@2%');
define('NONCE_SALT',       '%2t$j&|o`myc4A1QUXgUt|0s2{`sS_+OTux^wRNO);f`BwI5wI}-B_`n%;Zd%x-c');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');