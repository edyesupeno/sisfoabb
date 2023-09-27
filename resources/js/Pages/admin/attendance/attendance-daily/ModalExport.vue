<script setup>
import axios from "axios";
import dayjs from "dayjs";
import { onMounted, ref } from "vue";
import { bool, object, any } from "vue-types";
import { notify } from "notiwind";
import VDialog from "@/components/VDialog/index.vue";
import VButton from "@/components/VButton/index.vue";
import VSelect from "@/components/VSelect/index.vue";

const props = defineProps({
  openDialog: bool(),
  additional: object().def({}),
  branch: any(),
});

const emit = defineEmits(["close", "successDownload"]);

const isLoading = ref(false);
const formError = ref({});
const form = ref({
  date: new Date()
});
const branchSelectHandle = ref();

const handleDateRange = () => {
  // const dateStart = new Date(
  //   form.value.date[0].getFullYear(),
  //   form.value.date[0].getMonth(),
  //   form.value.date[0].getDate()
  // );
  // const dateEnd = new Date(
  //   form.value.date[1].getFullYear(),
  //   form.value.date[1].getMonth(),
  //   form.value.date[1].getDate()
  // );

  // form.value.start_date = dayjs(dateStart).format("YYYY-MM-DD");
  // form.value.end_date = dayjs(dateEnd).format("YYYY-MM-DD");
  form.value.filterdate = dayjs(form.value.date).format("YYYY-MM-DD");
};

const openForm = () => {
  form.value = ref({});
  form.value.branch_id = props.branch;
  form.value.date = new Date();
};

const closeForm = () => {
  branchSelectHandle.value.clearSelected();
  form.value = ref({});
  formError.value = ref({});
};

const submit = async () => {
  console.log(form.value);
  downloadExcel();
};

const downloadExcel = async () => {
  isLoading.value = true;
  axios
    .get(
      route("attendance.attendance-daily.exportAttendanceDaily", {
        branch_id: form.value.branch_id,
        filter_date: form.value.filterdate
      }),
      {
        responseType: "blob",
      }
    )
    .then((res) => {
      const contentDisposition = res.headers["content-disposition"];
      const fileName = contentDisposition
        ? contentDisposition.split("filename=")[1].trim()
        : "download.xlsx";

      const url = window.URL.createObjectURL(new Blob([res.data]));
      const link = document.createElement("a");
      link.href = url;
      link.setAttribute("download", fileName);
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);

      emit("close");
      emit("successDownload");
      form.value = ref({});
      notify(
        {
          type: "success",
          group: "top",
          text: "Download Sukses",
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
    title="Export Attendance Daily"
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
        <div class="col-span-2">
          <VSelect
            placeholder="Select Branch"
            :required="true"
            v-model="form.branch_id"
            :options="additional.branch_list"
            label="Branch"
            :errorMessage="formError.branch_id"
            ref="branchSelectHandle"
            :disabled="true"
          />
        </div>
        <div class="col-span-2">
          <label class="block text-sm font-medium text-slate-600 mb-1">
            Date <span class="text-rose-500">*</span>
          </label>
          <Datepicker
            v-model="form.date"
            @update:modelValue="handleDateRange"
            :enableTimePicker="false"
            position="left"
            :clearable="false"
            format="dd MMMM yyyy"
            previewFormat="dd MMMM yyyy"
            placeholder="Select Date"
            :class="{ date_error: formError.date }"
          />
          <div
            class="text-xs"
            :class="[
              {
                'text-rose-500': formError.date,
              },
            ]"
            v-if="formError.date"
          >
            {{ formError.date }}
          </div>
        </div>
      </div>
    </template>
    <template v-slot:footer>
      <div class="flex flex-wrap justify-end space-x-2">
        <VButton label="Cancel" type="default" @click="$emit('close')" />
        <VButton
          :is-loading="isLoading"
          label="Export Attendance"
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