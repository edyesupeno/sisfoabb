<script>
export default {
  layout: AppLayout,
};
</script>
<script setup>
import axios from "axios";
import dayjs from "dayjs";
import { notify } from "notiwind";
import { Head } from "@inertiajs/inertia-vue3";
import { ref, onMounted } from "vue";
import debounce from "@/composables/debounce";
import { object, string } from "vue-types";
import AppLayout from "@/layouts/apps.vue";
import VBreadcrumb from "@/components/VBreadcrumb/index.vue";
import VLoading from "@/components/VLoading/index.vue";
import VDataTable from "@/components/VDataTable/index.vue";
import VPagination from '@/components/VPagination/index.vue'
import VSelect from "@/components/VSelect/index.vue";
import VPresent from "@/components/src/icons/solid/VPresent.vue";
import VLate from "@/components/src/icons/solid/VLate.vue";
import VAbsent from "@/components/src/icons/solid/VAbsent.vue";
import VClockoutEarly from "@/components/src/icons/solid/VClockoutEarly.vue";
import VLeave from "@/components/src/icons/solid/VLeave.vue";
import VEmpty from "@/components/src/icons/VEmpty.vue";
import VHoliday from "@/components/src/icons/solid/VHoliday.vue";
import VUnassign from "@/components/src/icons/solid/VUnassign.vue";
import VModalForm from "./ModalForm.vue";
import VModalExport from "./ModalExport.vue";
import VButton from "@/components/VButton/index.vue";
import { Link } from "@inertiajs/inertia-vue3";

const itemSelected = ref({});
const openModalForm = ref(false);
const openModalExport = ref(false);
const attendanceQuery = ref([]);
const attendanceRecapQuery = ref([]);
const attendanceListHeader = ref([]);
const filterBranchValue = ref(1);

const breadcrumb = [
  {
    name: "Dashboard",
    active: false,
    to: route("dashboard.index"),
  },
  {
    name: "Attendance",
    active: false,
    to: route("attendance.attendance-daily.index"),
  },
  {
    name: "Daily",
    active: true,
    to: route("attendance.attendance-daily.index"),
  },
];
const overviewLoading = ref(true);
const attendanceListLoading = ref(true);

// const filter = ref({
//   date: {
//     month: dayjs().get("month"),
//     year: dayjs().get("year"),
//   },
//   currentDate: dayjs().format("dd MMMM YYYY"),
// });
const filter = ref({
  date: new Date()
});

const attendanceOverview = ref([
  {
    label: "Present",
    value: 0,
    type: "present",
  },
  {
    label: "Late",
    value: 0,
    type: "late",
  },
  {
    label: "Absent",
    value: 0,
    type: "absent",
  },
  {
    label: "Clockout Early",
    value: 0,
    type: "clockout_early",
  },
  {
    label: "Leave",
    value: 0,
    type: "leave",
  },
  {
    label: "Holiday",
    value: 0,
    type: "holiday",
  },
]);

const props = defineProps({
  additional: object(),
  title: string(),
});

const handleDate = () => {
  if (filter.value.date) {
    filter.value.filterdate = dayjs(filter.value.date).format("YYYY-MM-DD");
    console.log(filter.value);
  }

  initData();
};

const getAttendanceOverviewData = debounce(async (page) => {
  axios
    .get(route("attendance.attendance-daily.getdataoverview"), {
      params: {
        filter_date: filter.value.filterdate,
        filter_branch: filterBranchValue.value,
      },
    })
    .then((res) => {
      let present = attendanceOverview.value.find((e) => e.type === "present");
      let absent = attendanceOverview.value.find((e) => e.type === "absent");
      let late = attendanceOverview.value.find((e) => e.type === "late");
      let clockout_early = attendanceOverview.value.find(
        (e) => e.type === "clockout_early"
      );
      let leave = attendanceOverview.value.find((e) => e.type === "leave");
      let holiday = attendanceOverview.value.find((e) => e.type === "holiday");

      present.value = res.data.data.total_present;
      absent.value = res.data.data.total_absent;
      late.value = res.data.data.total_late;
      clockout_early.value = res.data.data.total_clockout_early;
      leave.value = res.data.data.total_leaves;
      holiday.value = res.data.data.total_holiday;
    })
    .catch((res) => {
      notify(
        {
          type: "error",
          group: "top",
          text: res.response.data.message,
        },
        2500
      );
    })
    .finally(() => (overviewLoading.value = false));
}, 500);


const pagination = ref({
    count: '',
    current_page: 1,
    per_page: '',
    total: 0,
    total_pages: 1
})

const nextPaginate = () => {
    pagination.value.current_page += 1
    attendanceListLoading.value = true
    getAttendanceListData(pagination.value.current_page)
}

const previousPaginate = () => {
    pagination.value.current_page -= 1
    attendanceListLoading.value = true
    getAttendanceListData(pagination.value.current_page)
}

const getAttendanceListData = debounce(async (page) => {
  axios
    .get(route("attendance.attendance-daily.getdata"), {
      params: {
        page: page,
        filter_date: filter.value.filterdate,
        filter_branch: filterBranchValue.value,
      },
    })
    .then((res) => {
      attendanceQuery.value = res.data.data;
      pagination.value = res.data.meta.pagination
    })
    .catch((res) => {
      notify(
        {
          type: "error",
          group: "top",
          text: res.response.data.message,
        },
        2500
      );
    })
    .finally(() => (attendanceListLoading.value = false));
}, 500);

const filterBranch = () => {
  initData();
};

const initData = () => {
  overviewLoading.value = true;
  attendanceListLoading.value = true;
  getAttendanceOverviewData();
  getAttendanceListData(1);
};

const closeModalForm = () => {
  itemSelected.value = ref({});
  openModalForm.value = false;
};

const handleAddModalExport = () => {
  openModalExport.value = true;
};

const successExport = () => {
  openModalExport.value = false;
};

const closeModalExport = () => {
  openModalExport.value = false;
};

onMounted(() => {
  filterBranchValue.value = props.additional.branch_id;
  initData();
});
</script>

<template>
  <Head :title="title"></Head>
  <VBreadcrumb :routes="breadcrumb" />
  <div class="mb-4 sm:mb-6 flex justify-between">
    <h1 class="text-2xl md:text-3xl text-slate-800 font-bold">
      Attendance Daily
    </h1>
    <div class="flex flex-1 items-center justify-end">
      <!-- Export -->
      <VButton
        label="Export"
        type="primary"
        @click="handleAddModalExport"
        class="mt-auto mr-2"
      />
      <VSelect
        placeholder="Select Branch"
        v-model="filterBranchValue"
        :options="additional.branch_list"
        class="w-1/6"
        :clearable="false"
        @update:modelValue="filterBranch"
      />
    </div>
  </div>

  <!-- Attendance Overview -->
  <div class="bg-white shadow-lg rounded-md mb-8 p-4">
    <div class="mb-5 flex justify-between items-center">
      <h1 class="text-xl text-slate-800 font-semibold">Daily Overview</h1>
      <div class="inline-flex space-x-2">
        <!-- <VButton label="Export" type="outline-primary" class="my-auto" /> -->
        <Datepicker
          v-model="filter.date"
          @update:modelValue="handleDate"
          :enableTimePicker="false"
          position="left"
          :clearable="false"
          format="dd MMMM yyyy"
          previewFormat="dd MMMM yyyy"
          placeholder="Select Date"
        />
      </div>
    </div>
    <div
      class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-6"
    >
      <div
        class="rounded border py-4 pr-4 flex"
        v-for="(data, index) in attendanceOverview"
        :key="index"
      >
        <div
          class="w-1.5 rounded-r mr-4"
          :class="{
            'bg-blue-500': data.type === 'present',
            'bg-red-500': data.type === 'absent',
            'bg-amber-500': data.type === 'late',
            'bg-cyan-600': data.type === 'clockout_early',
            'bg-pink-500': data.type === 'leave',
            'bg-yellow-400': data.type === 'holiday',
          }"
        ></div>
        <div class="text-slate-800">
          <div class="font-medium text-base">
            {{ data.label }}
          </div>
          <div v-if="overviewLoading" class="mt-1">
            <VLoading />
          </div>
          <div v-else>
            <div class="font-semibold text-3xl">
              {{ data.value }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Attendance List -->
  <div class="bg-white shadow-lg rounded-sm mb-8">
    <div class="flex flex-col md:flex-row md:-mr-px">
      <div class="grow">
        <div class="py-6 px-4">
          <div class="font-semibold text-xl text-slate-800">All Attendance</div>
          <div class="flex justify-between">
            <div class="text-slate-500 font-medium text-sm">
              {{ filter.currentMonth }}
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Table -->
    <section class="pb-6 px-4">
      <div v-if="attendanceListLoading">
        <VLoading />
      </div>
      <VDataTable
        :heads="[
          'Employee Name',
          'Type',
          'Schedule',
          'Clock In',
          'Clock Out',
          'Date',
        ]"
        v-if="!attendanceListLoading"
        wrapperClass="!px-0"
        :freezeTable="true"
      >
        <tr v-if="attendanceQuery.length === 0 && !attendanceListLoading">
          <td
            class="overflow-hidden my-2"
            :colspan="attendanceListHeader.length"
          >
            <div class="flex items-center flex-col w-full my-32">
              <VEmpty />
              <div class="mt-9 text-slate-500 text-xl md:text-xl font-medium">
                Result not found.
              </div>
            </div>
          </td>
        </tr>
        <tr
          v-for="(data, index) in attendanceQuery"
          :key="index"
          class="border-b-2"
          v-else
        >
          <td class="px-4 whitespace-nowrap h-10 fixed-left">
            {{ data.employee_name }}
          </td>
          <td class="px-4 whitespace-nowrap h-10 text-right">
            <div
              class="py-[2px] px-4 bg-amber-100 text-white rounded-full inline-flex"
              style="font-size: 12px"
              v-if="data.attendances.status == 'late'"
            >
              <VLate class="my-auto mr-2" />
              <span class="text-amber-600">Late</span>
            </div>
            <div
              class="py-[2px] px-4 bg-blue-100 text-white rounded-full inline-flex"
              style="font-size: 12px"
              v-else-if="data.attendances.status == 'present'"
            >
              <VPresent class="my-auto mr-2" />
              <span class="text-blue-600">Present</span>
            </div>
            <div
              class="py-[2px] px-4 bg-red-100 text-white rounded-full inline-flex"
              style="font-size: 12px"
              v-else-if="data.attendances.status == 'absent'"
            >
              <VAbsent class="my-auto mr-2" />
              <span class="text-red-600">Absent</span>
            </div>
            <div
              class="py-[2px] px-4 bg-cyan-100 text-white rounded-full inline-flex"
              style="font-size: 12px"
              v-else-if="data.attendances.status == 'checkout_early'"
            >
              <VClockoutEarly class="my-auto mr-2" />
              <span class="text-cyan-600">Clockout Early</span>
            </div>
            <div
              class="py-[2px] px-4 bg-pink-100 text-white rounded-full inline-flex"
              style="font-size: 12px"
              v-else-if="data.attendances.status == 'leave'"
            >
              <VLeave class="my-auto mr-2" />
              <span class="text-pink-600">Leave</span>
            </div>
            <div
              class="py-[2px] px-4 bg-yellow-100 text-white rounded-full inline-flex"
              style="font-size: 12px"
              v-else-if="data.attendances.status == 'holiday'"
            >
              <VHoliday class="my-auto mr-2" />
              <span class="text-yellow-600">Holiday</span>
            </div>
            <div
              class="py-[2px] px-2 bg-grey text-white rounded-full inline-flex"
              style="font-size: 12px"
              v-else
            ></div>
          </td>
          <td class="px-4 whitespace-nowrap h-10 text-right">
            <span
              v-if="
                data.schedules != null && data.schedules.shift_detail != null
              ">
              {{ data.schedules.shift_detail.start_time }} -
              {{ data.schedules.shift_detail.end_time }}
              </span>
            <div
              class="py-[2px] px-2 bg-grey text-white rounded-full inline-flex"
              style="font-size: 12px"
              v-else
            ></div>
          </td>
          <td class="px-4 whitespace-nowrap h-10 text-right">
            <span
              v-if="
                data.attendances.clock_in != null && data.attendances.clock_in != '-'
              ">
              {{ data.attendances.clock_in }}
              </span>
            <div
              class="py-[2px] px-2 bg-grey text-white rounded-full inline-flex"
              style="font-size: 12px"
              v-else
            ></div>
          </td>
          <td class="px-4 whitespace-nowrap h-10 text-right">
            <span
              v-if="
                data.attendances.clock_out != null && data.attendances.clock_out != '-'
              ">
              {{ data.attendances.clock_out }}
              </span>
            <div
              class="py-[2px] px-2 bg-grey text-white rounded-full inline-flex"
              style="font-size: 12px"
              v-else
            ></div>
          </td>
          <td class="px-4 whitespace-nowrap h-10 text-right">
            <span>{{ dayjs(data.date).format("DD MMMM YYYY")}}</span>
          </td>
        </tr>
      </VDataTable>
      <div class="py-6">
          <VPagination :pagination="pagination" @next="nextPaginate" @previous="previousPaginate" />
      </div>
    </section>
  </div>

  <VModalExport
    :open-dialog="openModalExport"
    @close="closeModalExport"
    @successSubmit="successExport"
    :additional="additional"
    :branch="filterBranchValue"
  />
  <VModalForm
    :data="itemSelected"
    :open-dialog="openModalForm"
    @close="closeModalForm"
  />
</template>

<style scoped>
.dp__main.dp__theme_light {
  width: 168px;
}
</style>