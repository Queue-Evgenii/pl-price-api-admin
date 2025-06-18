<script setup lang="ts">
  import { ref } from 'vue'
  import type { FormInst, FormRules } from 'naive-ui'
  import { NCard, NForm, NFormItem, NInput, NButton } from 'naive-ui'

  const formRef = ref<FormInst | null>(null)

  const form = ref({
    email: '',
    password: ''
  })
  const rules: FormRules = {
    email: [
      { required: true, message: 'Email is required', trigger: 'blur' },
      { type: 'email', message: 'Should satisfy pattern: example@gmail.com', trigger: 'blur'  }
    ],
    password: [
      { required: true, message: 'Password is required', trigger: 'blur' },
    ]
  }

  const handleLogin = () => {
    formRef.value?.validate((errors) => {
      if (!errors) {
        console.log('Данные формы:', form.value)
      }
    })
  }
</script>

<template>
  <n-card title="Авторизация" class="form">
    <n-form
      ref="formRef"
      :model="form"
      :rules="rules"
      label-placement="top"
    >
      <n-form-item label="Email" path="email">
        <n-input v-model:value="form.email" placeholder="Enter your email" />
      </n-form-item>

      <n-form-item label="Пароль" path="password">
        <n-input
          v-model:value="form.password"
          type="password"
          show-password-on="click"
          placeholder="Enter your password"
        />
      </n-form-item>

      <n-button @click="handleLogin" block type="primary">Войти</n-button>
    </n-form>
  </n-card>
</template>

<style scoped>
.form {
  max-width: 400px;
  margin: 40px auto 0;
}
</style>
