<script setup>
import axios from "axios";
import { ref } from "vue";
import { bool, object } from "vue-types";
import { notify } from "notiwind";
import VDialog from "@/components/VDialog/index.vue";
import VButton from "@/components/VButton/index.vue";
import VInput from "@/components/VInput/index.vue";
import VSelect from "@/components/VSelect/index.vue";
import VSwitch from "@/components/VSwitch/index.vue";

const props = defineProps({
  openDialog: bool(),
  updateAction: bool().def(false),
  data: object().def({}),
  additional: object().def({}),
});

const emit = defineEmits(["close", "successSubmit"]);

const typeSelectHandle = ref();
const isLoading = ref(false);
const formError = ref({});
const form = ref({});
const typeOptions = ref({
  earning: "Earning",
  deduction: "Deduction",
});

const payTypeOptions = ref({
  fix: "Fix",
  attendance: "Attendance",
  overtime_days: "Overtime Days",
  overtime_hours: "Overtime Hours"
});

const openForm = () => {
  if (props.updateAction) {
    form.value = Object.assign(form.value, props.data);
    initFormValue();
  } else {
    form.value = ref({});
  }
};

const closeForm = () => {
  if (!props.updateAction) {
    typeSelectHandle.value.clearSelected();
  }
  form.value = ref({});
  formError.value = ref({});
};

const initFormValue = () => {
  if (
    form.value.is_mandatory &&
    form.value.custom_attribute.action === "deduction_late"
  ) {
    form.value.late_tolerance = props.data.custom_attribute.late_tolerance;
    form.value.action = props.data.custom_attribute.action;
  } else if (
    form.value.is_mandatory &&
    form.value.custom_attribute.action === "earning_overtime"
  ) {
    form.value.action = props.data.custom_attribute.action;
  } else {
    form.value.action = "default";
  }
};

const submit = async () => {
  props.updateAction ? updateHandle() : createHandle();
};

const createHandle = async () => {
  isLoading.value = true;
  axios
    .post(route("settings.payroll.components.create"), form.value)
    .then((res) => {
      emit("close");
      emit("successSubmit");
      form.value = ref({});
      notify(
        {
          type: "success",
          group: "top",
          text: res.data.meta.message,
        },
        2500
      );
    })
    .catch((res) => {
      // Handle validation errors
      const result = res.response.data;
      const metaError = res.response.data.meta?.error;
      if (result.hasOwnProperty("errors")) {
        formError.value = ref({});
        Object.keys(result.errors).map((key) => {
          formError.value[key] = result.errors[key].toString();
        });
      }

      if (metaError) {
        notify(
          {
            type: "error",
            group: "top",
            text: metaError,
          },
          2500
        );
      } else {
        notify(
          {
            type: "error",
            group: "top",
            text: result.message,
          },
          2500
        );
      }
    })
    .finally(() => (isLoading.value = false));
};

const updateHandle = async () => {
  isLoading.value = true;
  axios
    .put(
      route("settings.payroll.components.update", { id: props.data.id }),
      form.value
    )
    .then((res) => {
      emit("close");
      emit("successSubmit");
      form.value = ref({});
      notify(
        {
          type: "success",
          group: "top",
          text: res.data.meta.message,
        },
        2500
      );
    })
    .catch((res) => {
      // Handle validation errors
      const result = res.response.data;
      const metaError = res.response.data.meta?.error;
      if (result.hasOwnProperty("errors")) {
        formError.value = ref({});
        Object.keys(result.errors).map((key) => {
          formError.value[key] = result.errors[key].toString();
        });
      }

      if (metaError) {
        notify(
          {
            type: "error",
            group: "top",
            text: metaError,
          },
          2500
        );
      } else {
        notify(
          {
            type: "error",
            group: "top",
            text: result.message,
          },
          2500
        );
      }
    })
    .finally(() => (isLoading.value = false));
};
</script>

<template>
  <VDialog
    :showModal="openDialog"
    :title="updateAction ? 'Update Component' : 'Add Component'"
    @opened="openForm"
    @closed="closeForm"
    size="md"
  >
    <template v-slot:close>
      <button
        class="text-slate-400 hover:text-slate-500"
        @click="$emit('close')"
      >
        <div class="sr-only">Close</div>
        <svg class="w-4 h-4 fill-current">
          <path
            d="M7.95 6.536l4.242-4.243a1 1 0 111.415 1.414L9.364 7.95l4.243 4.242a1 1 0 11-1.415 1.415L7.95 9.364l-4.243 4.243a1 1 0 01-1.414-1.415L6.536 7.95 2.293 3.707a1 1 0 011.414-1.414L7.95 6.536z"
          />
        </svg>
      </button>
    </template>
    <template v-slot:content>
      <!-- Deduction Late -->
      <div
        class="grid grid-cols-2 gap-3"
        v-if="
          form.is_mandatory && form.custom_attribute.action === 'deduction_late'
        "
      >
        <div class="col-span-2">
          <VInput
            placeholder="Input Late Tolerance"
            label="Late Tolerance (minute)"
            :required="true"
            v-model="form.late_tolerance"
            :errorMessage="formError.late_tolerance"
            @update:modelValue="formError.late_tolerance = ''"
          />
        </div>
        <VSwitch v-model="form.is_editable" label="Editable" type="block" />
        <VSwitch v-model="form.is_taxable" label="Taxable" type="block" />
      </div>

      <!-- Deduction Late -->
      <div
        class="grid grid-cols-2 gap-3"
        v-else-if="
          form.is_mandatory &&
          form.custom_attribute.action === 'earning_overtime'
        "
      >
        <VSwitch v-model="form.is_editable" label="Editable" type="block" />
        <VSwitch v-model="form.is_taxable" label="Taxable" type="block" />
      </div>

      <!-- Custom Component -->
      <div class="grid grid-cols-2 gap-3" v-else>
        <div class="col-span-2">
          <VInput
            placeholder="Insert Name"
            label="Name"
            :required="true"
            v-model="form.name"
            :errorMessage="formError.name"
            @update:modelValue="formError.name = ''"
          />
        </div>
        <div class="col-span-2">
          <VSelect
            placeholder="Select Type"
            :required="true"
            v-model="form.type"
            :options="typeOptions"
            label="Type"
            :errorMessage="formError.type"
            @update:modelValue="formError.type = ''"
            ref="typeSelectHandle"
          />
          <!-- <VSelect
            placeholder="Select Type"
            :required="true"
            v-model="form.type"
            :options="typeOptions"
            label="Type"
            :errorMessage="formError.type"
            @update:modelValue="formError.type = ''"
            ref="typeSelectHandle"
            :disabled="updateAction"
          /> -->
        </div>
        <div class="col-span-2">
          <VSelect
            placeholder="Select Type"
            :required="true"
            v-model="form.pay_type"
            :options="payTypeOptions"
            label="Pay Type"
            :errorMessage="formError.pay_type"
            @update:modelValue="formError.pay_type = ''"
            ref="typeSelectHandle"
          />
          <!-- <VSelect
            placeholder="Select Type"
            :required="true"
            v-model="form.pay_type"
            :options="payTypeOptions"
            label="Pay Type"
            :errorMessage="formError.pay_type"
            @update:modelValue="formError.pay_type = ''"
            ref="typeSelectHandle"
            :disabled="updateAction"
          /> -->
        </div>
          <VSwitch v-model="form.is_editable" label="Editable" type="block" />
          <!-- <VSwitch v-model="form.is_atendance" label="Atendance" type="block" /> -->
          <VSwitch v-model="form.is_taxable" label="Taxable" type="block" />
      </div>
    </template>
    <template v-slot:footer>
      <div class="flex flex-wrap justify-end space-x-2">
        <VButton label="Cancel" type="default" @click="$emit('close')" />
        <VButton
          :is-loading="isLoading"
          :label="updateAction ? 'Update' : 'Create'"
          type="primary"
          @click="submit"
        />
      </div>
    </template>
  </VDialog>
</template>

<style>
.dp__select {
  color: #4f8cf6 !important;
}

.date_error {
  --dp-border-color: #dc3545 !important;
}
</style>
