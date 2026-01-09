const admin = require('firebase-admin');

function getFirebaseAdmin() {
  if (admin.apps.length) return admin;

  const json = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
  if (!json) throw new Error('Missing FIREBASE_SERVICE_ACCOUNT_JSON env var');

  const serviceAccount = JSON.parse(json);

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });

  return admin;
}

module.exports = { getFirebaseAdmin };
