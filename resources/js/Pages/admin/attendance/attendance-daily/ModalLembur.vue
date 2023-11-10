<script setup>
import axios from "axios";
import dayjs from "dayjs";
import { onMounted, ref, defineEmits } from "vue";
import { bool, object, any } from "vue-types";
import { notify } from "notiwind";
import VDialog from "@/components/VDialog/index.vue";
import VButton from "@/components/VButton/index.vue";
import VSelect from "@/components/VSelect/index.vue";
import VInput from "@/components/VInput/index.vue";

const props = defineProps({
  openDialog: bool(),
  additional: object().def({}),
  branch: any(),
  datas: object().def({}),
});

const emit = defineEmits(["close", "successUpdate"]);

const isLoading = ref(false);
const formError = ref({});
const form = ref({});

const handleClock = () => {
//   form.value.clock_in_current = `${form.value.clock_in.hours}:${form.value.clock_in.minutes}:00`;
//   form.value.clock_out_current = `${form.value.clock_out.hours}:${form.value.clock_out.minutes}:00`;
  console.log(form.value);
};

const openForm = () => {
  form.value = ref({});
  form.value.branch_id = props.branch;
  form.value.date = new Date();
  form.value.keterangan = '';
    // form.value.clock_in = {
    //   hours: props.datas.clock_in.split(':')[0],
    //   minutes: props.datas.clock_in.split(':')[1],
    //   seconds: 0
    // };
    // form.value.clock_in_current = `${form.value.clock_in.hours}:${form.value.clock_in.minutes}`;

    // form.value.clock_out = {
    //   hours: props.datas.clock_out.split(':')[0],
    //   minutes: props.datas.clock_out.split(':')[1],
    //   seconds: 0
    // };
    // form.value.clock_out_current = `${form.value.clock_out.hours}:${form.value.clock_out.minutes}`;
};

const closeForm = () => {
  form.value = ref({});
  formError.value = ref({});
};

const submit = async () => {
  console.log(form.value);
  saveLembur();
};

const saveLembur = async () => {
  isLoading.value = true;
  axios
    .post(route("attendance.attendance-daily.saveLembur"), {
      user_id: props.datas.employee_user_id,
      clock_in: `${form.value.clock_in.hours}:${form.value.clock_in.minutes}:00`,
      clock_out: `${form.value.clock_out.hours}:${form.value.clock_out.minutes}:00`,
      note: form.value.keterangan,
      branch_id: props.branch,
      date: props.datas.date
    })
    .then((res) => {
      console.log(res.data);

      emit("close");
      emit("successUpdate");
      form.value = ref({});
      notify(
        {
          type: "success",
          group: "top",
          text: "Input Lembur Sukses",
        },
        2500
      );
    })
    .catch((res) => {
      // Handle validation errors
      const result = res.response.data;
      if (result.hasOwnProperty("errors")) {
        formError.value = ref({});
        Object.keys(result.errors).map((key) => {
          formError.value[key] = result.errors[key].toString();
        });
      }

      notify(
        {
          type: "error",
          group: "top",
          text: result.message,
        },
        2500
      );
    })
    .finally(() => (isLoading.value = false));
};
</script>



<template>
  <VDialog
    :showModal="openDialog"
    title="Input Lembur"
    @opened="openForm"
    @closed="closeForm"
    size="xl"
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
      <div class="grid grid-cols-2 gap-3">
        <div>
          <label class="block text-sm font-medium text-slate-600 mb-1">
            Clock In <span class="text-rose-500">*</span>
          </label>
          <Datepicker
            v-model="form.clock_in"
            @update:modelValue="handleClock()"
            time-picker
            position="left"
            :clearable="true"
            placeholder="00:00"
            :class="{ date_error: formError.clock_in }"
          />
          <div
            class="text-xs mt-1"
            :class="[
              {
                'text-rose-500': formError.clock_in,
              },
            ]"
            v-if="formError.clock_in"
          >
            {{ formError.clock_in }}
          </div>
        </div>
        <div>
          <label class="block text-sm font-medium text-slate-600 mb-1">
            Clock Out <span class="text-rose-500">*</span>
          </label>
          <Datepicker
            v-model="form.clock_out"
            @update:modelValue="handleClock()"
            time-picker
            position="left"
            :clearable="true"
            placeholder="00:00"
            :class="{ date_error: formError.clock_out }"
          />
          <div
            class="text-xs mt-1"
            :class="[
              {
                'text-rose-500': formError.clock_out,
              },
            ]"
            v-if="formError.clock_out"
          >
            {{ formError.clock_out }}
          </div>
        </div>
        <div class="col-span-2">
          <VInput
            placeholder="Input Keteranagan Lembur"
            label="Keterangan"
            :required="true"
            v-model="form.keterangan"
            :errorMessage="formError.keterangan"
            @update:modelValue="formError.keterangan = ''"
          />
        </div>
      </div>
    </template>
    <template v-slot:footer>
      <div class="flex flex-wrap justify-end space-x-2">
        <VButton label="Cancel" type="default" @click="$emit('close')" />
        <VButton
          :is-loading="isLoading"
          label="Save"
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