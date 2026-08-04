Contributing to StimOn-StimOff_Cognition

Thank you for your interest in contributing to this repository, which provides code reproducing analyses from our "Switching off subthalamic deep brain stimulation in Parkinson’s disease worsens reaction time and executive function independent of motor effects" paper . We welcome contributions that enhance reproducibility, fix bugs, improve documentation, or extend analysis while maintaining scientific accuracy.

Code of Conduct

This project follows the Contributor Covenant Code of Conduct. By participating, you agree to uphold it.[web:11]

Suggested Contributions

Bug reports in analysis scripts or data processing
Documentation improvements for reproducibility
New tests ensuring results match published paper figures/tables
Performance optimizations without altering scientific outputs
Contributions altering core results or introducing unvalidated methods require discussion first.

How to Contribute

Check open issues
Fork the repo and clone locally: git clone https://github.com/yourusername/your-repo.git.
Create a feature branch: git checkout -b feature/your-feature-name (reference paper section if relevant).
Install dependencies: Use environment.yml or requirements.txt; prefer conda for reproducibility in biomedical research.
Make changes: Follow style guidelines below; preserve exact outputs from original analyses.
Test thoroughly: Run full pipeline; new tests must pass and match paper results (e.g., via pytest).
Commit and push: Use clear messages and descriptions
Open a Pull Request: Link to related issue/paper section; include before/after results.
Style Guidelines

Code: avoid changes to core analysis logic.
Documentation: Update README/ notebooks with any changes; cite paper sections.
Data: Never commit sensitive medical data; use synthetic/public datasets only.
Ethics: Flag potential biases and comply with DSGVO
