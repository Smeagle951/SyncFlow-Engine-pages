const fs = require('fs');
const path = require('path');

class AuditLogger {
  constructor() {
    this.logDir = path.join(__dirname, '../../logs');
    this.ensureLogDirectory();
  }

  ensureLogDirectory() {
    if (!fs.existsSync(this.logDir)) {
      fs.mkdirSync(this.logDir, { recursive: true });
    }
  }

  getLogFileName() {
    const today = new Date().toISOString().split('T')[0];
    return path.join(this.logDir, `audit-${today}.log`);
  }

  log(level, action, details) {
    const timestamp = new Date().toISOString();
    const logEntry = {
      timestamp,
      level,
      action,
      details: typeof details === 'object' ? JSON.stringify(details) : details
    };

    const logLine = `${timestamp} [${level}] ${action}: ${logEntry.details}\n`;

    // Escrever no arquivo
    fs.appendFileSync(this.getLogFileName(), logLine, 'utf8');

    // Também logar no console em desenvolvimento
    if (process.env.NODE_ENV !== 'production') {
      console.log(`[AUDIT] ${logLine.trim()}`);
    }
  }

  logSync(action, details) {
    this.log('SYNC', action, details);
  }

  logConflict(uuid, details) {
    this.log('CONFLICT', `Conflict detected: ${uuid}`, details);
  }

  logError(action, error) {
    this.log('ERROR', action, {
      message: error.message,
      stack: error.stack
    });
  }

  logAuth(action, details) {
    this.log('AUTH', action, details);
  }
}

module.exports = new AuditLogger();
