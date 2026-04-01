<template>
  <div class="privacy-policy">
    <div class="privacy-policy__back-button">
      <router-link to="/" class="privacy-policy__back-link">
        <n-flex align="center" justify="center">
          <span>← Back</span>
        </n-flex>
      </router-link>
    </div>
    <div class="privacy-policy__container">
      <h1 class="privacy-policy__title">Privacy Policy</h1>

      <div class="privacy-policy__content">
        <div class="privacy-policy__updated">
          <strong>Last updated:</strong> {{ new Date().toLocaleDateString() }}
        </div>

        <section class="privacy-policy__section">
          <h2 class="privacy-policy__section-title">1. Information We Collect</h2>

          <div class="privacy-policy__subsection">
            <h3 class="privacy-policy__subsection-title">1.1 Personal Data</h3>
            <p class="privacy-policy__text">We may collect the following personal information:</p>
            <ul class="privacy-policy__list">
              <li>Email address (if provided)</li>
              <li>Name and contact information</li>
              <li>Usage data and preferences</li>
            </ul>
          </div>

          <div class="privacy-policy__subsection">
            <h3 class="privacy-policy__subsection-title">1.2 Technical Data</h3>
            <p class="privacy-policy__text">We automatically collect technical information:</p>
            <ul class="privacy-policy__list">
              <li>IP address and location data</li>
              <li>Browser type and version</li>
              <li>Device information</li>
              <li>Cookies and usage analytics</li>
            </ul>
          </div>
        </section>

        <section class="privacy-policy__section">
          <h2 class="privacy-policy__section-title">2. How We Use Your Information</h2>
          <p class="privacy-policy__text">We use collected data to:</p>
          <ul class="privacy-policy__list">
            <li>Provide and maintain our price viewing service</li>
            <li>Improve user experience and application performance</li>
            <li>Analyze usage patterns and optimize features</li>
            <li>Ensure security and prevent fraud</li>
            <li>Comply with legal obligations</li>
          </ul>
        </section>

        <section class="privacy-policy__section">
          <h2 class="privacy-policy__section-title">3. Data Storage and Security</h2>
          <p class="privacy-policy__text">
            Your data is stored securely on our servers with appropriate technical and organizational
            measures to protect against unauthorized access, alteration, or destruction.
          </p>
        </section>

        <section class="privacy-policy__section">
          <h2 class="privacy-policy__section-title">4. Data Sharing</h2>
          <p class="privacy-policy__text">
            We do not sell, trade, or otherwise transfer your personal information to third parties
            without your consent, except as described in this policy or required by law.
          </p>
        </section>

        <section class="privacy-policy__section">
          <h2 class="privacy-policy__section-title">5. Your Rights</h2>
          <p class="privacy-policy__text">Under GDPR and applicable data protection laws, you have the right to:</p>
          <ul class="privacy-policy__list">
            <li>Access your personal data</li>
            <li>Request correction of inaccurate data</li>
            <li>Request deletion of your personal data</li>
            <li>Object to processing of your data</li>
            <li>Request data portability</li>
          </ul>
        </section>

        <section class="privacy-policy__section">
          <h2 class="privacy-policy__section-title">6. Cookies</h2>
          <p class="privacy-policy__text">
            Our application uses cookies to enhance user experience, analyze traffic, and personalize content.
            You can control cookie settings through your browser preferences.
          </p>
        </section>

        <section class="privacy-policy__section">
          <h2 class="privacy-policy__section-title">7. Contact Information</h2>
          <p class="privacy-policy__text">
            If you have questions about this Privacy Policy or need to exercise your data protection rights,
            please contact us at:
          </p>
          <div class="privacy-policy__contact">
            <p><strong>Company:</strong> POLANDGROUPS Sp. z o.o.</p>
            <p><strong>NIP:</strong> 1132910509</p>
            <p><strong>Address:</strong> Biuro aleja Krakowska 121, Warszawa</p>
            <p><strong>Phone:</strong> +48 884 074 848</p>
            <p><strong>Email:</strong> sufitypolandgroup@gmail.com</p>
          </div>
        </section>

        <section class="privacy-policy__section">
          <h2 class="privacy-policy__section-title">8. Policy Updates</h2>
          <p class="privacy-policy__text">
            We may update this Privacy Policy from time to time. We will notify you of any changes
            by posting the new policy on this page and updating the "Last updated" date.
          </p>
        </section>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
// Privacy Policy page component
// Provides information about data collection and usage
</script>

<style scoped>
.privacy-policy {
  min-height: 100vh;
  background-color: #f8fafc;
  padding: 20px;
}

.privacy-policy__back-button {
  position: fixed;
  top: 20px;
  left: 20px;
  z-index: 1000;
}

.privacy-policy__back-link {
  display: inline-block;
  padding: 12px 24px;
  background-color: #3b82f6;
  color: white;
  text-decoration: none;
  border-radius: 8px;
  font-weight: 500;
  transition: all 0.3s ease;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.privacy-policy__back-link:hover {
  background-color: #2563eb;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.privacy-policy__back-link span {
  font-size: 16px;
}

.privacy-policy__container {
  max-width: 800px;
  margin: 0 auto;
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  padding: 40px;
}

.privacy-policy__title {
  font-size: 2.5rem;
  font-weight: 700;
  color: #1a202c;
  margin-bottom: 2rem;
  text-align: center;
}

.privacy-policy__content {
  line-height: 1.7;
}

.privacy-policy__updated {
  background-color: #f1f5f9;
  padding: 16px;
  border-radius: 8px;
  margin-bottom: 2rem;
  font-size: 0.95rem;
  color: #64748b;
}

.privacy-policy__section {
  margin-bottom: 3rem;
}

.privacy-policy__section-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: #1e293b;
  margin-bottom: 1.5rem;
  padding-bottom: 0.5rem;
  border-bottom: 2px solid #e2e8f0;
}

.privacy-policy__subsection {
  margin-bottom: 2rem;
  margin-left: 1rem;
}

.privacy-policy__subsection-title {
  font-size: 1.25rem;
  font-weight: 500;
  color: #334155;
  margin-bottom: 1rem;
}

.privacy-policy__text {
  color: #475569;
  margin-bottom: 1rem;
  font-size: 1rem;
  line-height: 1.8;
}

.privacy-policy__list {
  list-style: none;
  padding: 0;
  margin: 1rem 0;
}

.privacy-policy__list li {
  position: relative;
  padding: 12px 0 12px 32px;
  color: #475569;
  font-size: 1rem;
  line-height: 1.6;
  border-bottom: 1px solid #f1f5f9;
}

.privacy-policy__list li:last-child {
  border-bottom: none;
}

.privacy-policy__list li::before {
  content: "•";
  position: absolute;
  left: 12px;
  top: 12px;
  color: #3b82f6;
  font-weight: bold;
  font-size: 1.2rem;
}

.privacy-policy__contact {
  background-color: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  padding: 20px;
  margin-top: 1rem;
}

.privacy-policy__contact p {
  margin: 8px 0;
  color: #475569;
  font-size: 1rem;
}

.privacy-policy__contact strong {
  color: #1e293b;
  font-weight: 600;
}

@media (max-width: 768px) {
  .privacy-policy {
    padding: 16px;
  }

  .privacy-policy__back-button {
    top: 30px;
    left: 10px;
  }

  .privacy-policy__back-link {
    padding: 10px 20px;
  }

  .privacy-policy__back-link span {
    font-size: 14px;
  }

  .privacy-policy__container {
    padding: 24px;
    margin-top: 60px;
  }

  .privacy-policy__title {
    font-size: 2rem;
  }

  .privacy-policy__section-title {
    font-size: 1.25rem;
  }

  .privacy-policy__subsection-title {
    font-size: 1.1rem;
  }

  .privacy-policy__subsection {
    margin-left: 0.5rem;
  }
}
</style>
