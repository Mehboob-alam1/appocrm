import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'appomatrix_crm.db');
    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await _createSchema(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE call_logs ADD COLUMN disposition TEXT',
          );
        }
        if (oldVersion < 3) {
          await _createInvoicesTable(db);
        }
      },
    );
  }

  Future<void> _createSchema(Database db) async {
        await db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            pipeline TEXT NOT NULL,
            follow_up_at INTEGER,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            contact_id INTEGER NOT NULL,
            body TEXT NOT NULL,
            from_voice INTEGER NOT NULL,
            created_at INTEGER NOT NULL,
            FOREIGN KEY (contact_id) REFERENCES contacts (id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE call_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            contact_id INTEGER NOT NULL,
            created_at INTEGER NOT NULL,
            disposition TEXT,
            FOREIGN KEY (contact_id) REFERENCES contacts (id) ON DELETE CASCADE
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_contacts_follow_up ON contacts (follow_up_at)',
        );
        await db.execute(
          'CREATE INDEX idx_notes_contact ON notes (contact_id)',
        );
        await _createInvoicesTable(db);
  }

  Future<void> _createInvoicesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contact_id INTEGER NOT NULL,
        invoice_number TEXT NOT NULL,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        currency TEXT NOT NULL DEFAULT 'INR',
        status TEXT NOT NULL,
        notes TEXT,
        created_at INTEGER NOT NULL,
        due_at INTEGER,
        paid_at INTEGER,
        FOREIGN KEY (contact_id) REFERENCES contacts (id) ON DELETE CASCADE
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_invoices_contact ON invoices (contact_id)',
    );
  }
}
