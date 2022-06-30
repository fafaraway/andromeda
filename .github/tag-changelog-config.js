module.exports = {
    types: [
        { types: ["feat"], label: "New Features" },
        { types: ["fix"], label: "Bugfixes" },
        { types: ["improvement", "enhancement"], label: "Improvements" },
        { types: ["perf"], label: "Performance Optimizations" },
        { types: ["ci"], label: "Build System" },
        { types: ["refactor"], label: "Refactors" },
        { types: ["doc"], label: "Documentation Changes" },
        { types: ["test"], label: "Tests" },
        { types: ["style"], label: "Code Style Changes" },
        { types: ["chore"], label: "Chores" },
        { types: ["other"], label: "Other Changes" },
    ],

    // excludeTypes: ["ci", "doc", "test", "style", "chore", "other"],

    renderTypeSection: function (label, commits) {
        let text = `\n## ${label}\n`;

        commits.forEach((commit) => {
            text += `- ${commit.subject}\n`;
        });

        return text;
    },

    renderChangelog: function (release, changes) {
        const now = new Date();
        return `# ${release} - ${now.toISOString().substr(0, 10)}\n` + changes + "\n\n";
    },
};
