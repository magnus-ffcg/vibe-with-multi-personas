import { promises as fs } from 'fs';
import { join, resolve, dirname } from 'path';
import { createHash } from 'crypto';
export class ProjectIdentifier {
    static PROJECT_MARKERS = [
        'package.json',
        '.git',
        'pyproject.toml',
        'Cargo.toml',
        'go.mod',
        'composer.json',
        'pom.xml',
        'build.gradle',
        'Makefile',
        '.project'
    ];
    // Standard environment variables that might indicate project context
    static ENV_VARS = [
        'PWD', // Current working directory
        'OLDPWD', // Previous working directory
        'HOME' // User home directory for relative path calculation
    ];
    /**
     * Identify the current project based on directory structure and filesystem markers
     */
    static async identifyProject(startPath = process.cwd()) {
        const projectRoot = await this.findProjectRoot(startPath);
        const projectName = await this.getProjectName(projectRoot);
        const projectHash = this.generateProjectHash(projectRoot);
        return {
            id: `${projectName}-${projectHash}`,
            name: projectName,
            root: projectRoot,
            hash: projectHash
        };
    }
    /**
     * Find the project root by looking for common project markers
     */
    static async findProjectRoot(startPath) {
        let currentPath = resolve(startPath);
        const rootPath = resolve('/');
        while (currentPath !== rootPath) {
            // Check for project markers
            for (const marker of this.PROJECT_MARKERS) {
                const markerPath = join(currentPath, marker);
                try {
                    await fs.access(markerPath);
                    return currentPath; // Found a project marker
                }
                catch {
                    // Marker doesn't exist, continue
                }
            }
            // Move up one directory
            const parentPath = dirname(currentPath);
            if (parentPath === currentPath) {
                break; // Reached filesystem root
            }
            currentPath = parentPath;
        }
        // If no project root found, use the starting path
        return resolve(startPath);
    }
    /**
     * Get project name from various sources
     */
    static async getProjectName(projectRoot) {
        // Try package.json first
        try {
            const packageJsonPath = join(projectRoot, 'package.json');
            const packageJson = JSON.parse(await fs.readFile(packageJsonPath, 'utf-8'));
            if (packageJson.name) {
                return this.sanitizeProjectName(packageJson.name);
            }
        }
        catch {
            // package.json doesn't exist or is invalid
        }
        // Try pyproject.toml
        try {
            const pyprojectPath = join(projectRoot, 'pyproject.toml');
            const pyprojectContent = await fs.readFile(pyprojectPath, 'utf-8');
            const nameMatch = pyprojectContent.match(/name\s*=\s*["']([^"']+)["']/);
            if (nameMatch) {
                return this.sanitizeProjectName(nameMatch[1]);
            }
        }
        catch {
            // pyproject.toml doesn't exist or is invalid
        }
        // Try Cargo.toml
        try {
            const cargoPath = join(projectRoot, 'Cargo.toml');
            const cargoContent = await fs.readFile(cargoPath, 'utf-8');
            const nameMatch = cargoContent.match(/name\s*=\s*["']([^"']+)["']/);
            if (nameMatch) {
                return this.sanitizeProjectName(nameMatch[1]);
            }
        }
        catch {
            // Cargo.toml doesn't exist or is invalid
        }
        // Try go.mod
        try {
            const goModPath = join(projectRoot, 'go.mod');
            const goModContent = await fs.readFile(goModPath, 'utf-8');
            const moduleMatch = goModContent.match(/module\s+([^\s\n]+)/);
            if (moduleMatch) {
                const moduleName = moduleMatch[1].split('/').pop() || moduleMatch[1];
                return this.sanitizeProjectName(moduleName);
            }
        }
        catch {
            // go.mod doesn't exist or is invalid
        }
        // Fall back to directory name
        const dirName = projectRoot.split('/').pop() || 'unknown-project';
        return this.sanitizeProjectName(dirName);
    }
    /**
     * Generate a short hash for the project based on its absolute path
     */
    static generateProjectHash(projectRoot) {
        const hash = createHash('sha256');
        hash.update(projectRoot);
        return hash.digest('hex').substring(0, 8);
    }
    /**
     * Sanitize project name to be filesystem-safe
     */
    static sanitizeProjectName(name) {
        return name
            .toLowerCase()
            .replace(/[^a-z0-9-_]/g, '-')
            .replace(/-+/g, '-')
            .replace(/^-|-$/g, '')
            .substring(0, 50) || 'unnamed-project';
    }
    /**
     * Get the workflow state directory for a specific project
     */
    static async getProjectStateDir(baseDir = './.workflow-state') {
        const projectInfo = await this.identifyProject();
        return resolve(baseDir, projectInfo.id);
    }
    /**
     * Get debug information about available environment variables
     */
    static getEnvironmentDebugInfo() {
        const envInfo = {};
        // Check standard environment variables
        for (const envVar of this.ENV_VARS) {
            envInfo[envVar] = process.env[envVar];
        }
        // Add some additional context
        envInfo['NODE_ENV'] = process.env.NODE_ENV;
        envInfo['TERM'] = process.env.TERM;
        envInfo['SHELL'] = process.env.SHELL;
        return envInfo;
    }
    /**
     * Check if running in a development environment (basic heuristic)
     */
    static isDevelopmentEnvironment() {
        return !!(process.env.NODE_ENV === 'development' ||
            process.env.TERM || // Terminal environment
            process.cwd().includes('projects') || // Common project directory
            process.cwd().includes('workspace'));
    }
}
//# sourceMappingURL=project-identifier.js.map