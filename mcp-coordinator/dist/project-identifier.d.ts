export interface ProjectInfo {
    id: string;
    name: string;
    root: string;
    hash: string;
}
export declare class ProjectIdentifier {
    private static readonly PROJECT_MARKERS;
    private static readonly ENV_VARS;
    /**
     * Identify the current project based on directory structure and filesystem markers
     */
    static identifyProject(startPath?: string): Promise<ProjectInfo>;
    /**
     * Find the project root by looking for common project markers
     */
    private static findProjectRoot;
    /**
     * Get project name from various sources
     */
    private static getProjectName;
    /**
     * Generate a short hash for the project based on its absolute path
     */
    private static generateProjectHash;
    /**
     * Sanitize project name to be filesystem-safe
     */
    private static sanitizeProjectName;
    /**
     * Get the workflow state directory for a specific project
     */
    static getProjectStateDir(baseDir?: string): Promise<string>;
    /**
     * Get debug information about available environment variables
     */
    static getEnvironmentDebugInfo(): Record<string, string | undefined>;
    /**
     * Check if running in a development environment (basic heuristic)
     */
    static isDevelopmentEnvironment(): boolean;
}
//# sourceMappingURL=project-identifier.d.ts.map