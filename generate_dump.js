const fs = require('fs');
const { execSync } = require('child_process');
const path = require('path');

const outputFile = 'Full_Code_Claude.md';
let markdown = '';

// Add tree structure (Backend)
markdown += '# Struktur Direktori Backend (akademika-api)\n```text\n';
try {
    const treeBackend = execSync('tree akademika-api /A /F', { encoding: 'utf-8' });
    markdown += treeBackend;
} catch (e) {
    markdown += 'Tree command failed.\n';
}
markdown += '```\n\n';

// Add tree structure (Frontend)
markdown += '# Struktur Direktori Frontend (AkademikaFlutter)\n```text\n';
try {
    const treeFrontend = execSync('tree AkademikaFlutter /A /F', { encoding: 'utf-8' });
    markdown += treeFrontend;
} catch (e) {
    markdown += 'Tree command failed.\n';
}
markdown += '```\n\n';

// Files to include
const files = [
    // Backend
    { path: 'akademika-api/app/Models/Mahasiswa.php', lang: 'php' },
    { path: 'akademika-api/app/Http/Controllers/Api/MahasiswaController.php', lang: 'php' },
    { path: 'akademika-api/routes/api.php', lang: 'php' },
    { path: 'akademika-api/database/migrations/2026_05_06_041701_create_mahasiswas_table.php', lang: 'php' },
    // Frontend
    { path: 'AkademikaFlutter/lib/main.dart', lang: 'dart' },
    { path: 'AkademikaFlutter/lib/models/mahasiswa.dart', lang: 'dart' },
    { path: 'AkademikaFlutter/lib/services/api_service.dart', lang: 'dart' },
    { path: 'AkademikaFlutter/lib/screens/student_list_screen.dart', lang: 'dart' },
    { path: 'AkademikaFlutter/lib/screens/mahasiswa_form_screen.dart', lang: 'dart' }
];

markdown += '# Source Code Utama\n\n';

for (const file of files) {
    if (fs.existsSync(file.path)) {
        const content = fs.readFileSync(file.path, 'utf-8');
        markdown += `### File: ${file.path}\n`;
        markdown += '```' + file.lang + '\n';
        markdown += content;
        markdown += '\n```\n\n';
    }
}

fs.writeFileSync(outputFile, markdown);
console.log('File generated: ' + outputFile);