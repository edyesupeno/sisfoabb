<script>
export default {
  layout: AppLayout,
  name: "ERP ABB",
  components: {
    Doughnut,
  },
  data() {
    return {
      jumlah: "",

      chartData: {
        labels: ["January", "February", "March"],
        datasets: [{ data: [40, 20, 12] }],
      },
      chartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: "bottom",
          },
        },
      },
    };
  },
};
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from "chart.js";
import { Link } from "@inertiajs/inertia-vue3";
import { Doughnut } from "vue-chartjs";
import axios from "axios";
import debounce from "@/composables/debounce";
import { notify } from "notiwind";
const isLoading = ref(true);
var alldata = [];
var jumlah = "";
var data2 = {};
const getAttendanceListData = debounce(async (page) => {
  axios
    .get(route("attendance.attendance-overview.getdataoverview"), {
      params: {
        filter_date: new Date(),
        filter_branch: -10,
      },
    })
    .then((res) => {
      alldata = res.data.data;
      jumlah =
        alldata.total_absent +
        alldata.total_present +
        alldata.total_leaves +
        alldata.total_late +
        alldata.total_holiday +
        alldata.total_clockout_early;
      console.log(res.data);
      data2 = {
        labels: ["Present", "Absent", "Late", "Leave"],
        datasets: [
          {
            backgroundColor: ["#00c3ff", "#ff5e00", "#ffd900", "#f0706c"],
            data: [
              alldata.total_present,
              alldata.total_absent,
              alldata.total_late,
              alldata.total_leaves,
            ],
          },
        ],
      };
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
    .finally(() => (isLoading.value = false));
}, 500);

var dataProjectOffToday = ref([]);
const getProjectOffToday = debounce(async () => {
  axios
    .get(route("project.getalldata"))
    .then((res) => {
      console.log(res);
      dataProjectOffToday.value = res.data;
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
    .finally(() => (isLoading.value = false));
}, 500);

export const data = {
  labels: ["Complete 75%", "Ongoing 25%"],
  datasets: [
    {
      backgroundColor: ["#00c3ff", "#ffd900"],
      data: [76, 25],
    },
  ],
};

export const options = {
  responsive: true,
  maintainAspectRatio: false,
  cutout: 90,
  plugins: {
    legend: {
      position: "bottom",

      labels: {
        usePointStyle: true,
      },
      title: {
        display: true,
        text: "",
      },
    },
  },
};

ChartJS.register(ArcElement, Tooltip, Legend);
</script>
<style scoped>
.donut-inner {
  margin-top: -100px;
  margin-bottom: 100px;
}

.donut-inner h5 {
  margin-bottom: 5px;
  margin-top: 0;
}

.donut-inner span {
  font-size: 12px;
}
</style>

<template>
  <Head :title="'ERP ABB'"></Head>
  <div class="mb-4 sm:mb-6 flex justify-between items-center">
    <h1 class="text-2xl md:text-3xl text-slate-800 font-bold">Admin</h1>
  </div>
  <!-- <div class="grid grid-cols-3 gap-4">
    <div
      class="block rounded-lg bg-white shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)] h-auto"
    >
      <div
        class="border-b-2 border-neutral-100 font-medium px-6 py-3 grid grid-cols-2"
      >
        <h2>Attendance Today</h2>
        <div></div>
      </div>
      <div class="p-6 content-center">
        <div style="height: 300px; position: relative">
          <div
            style="
              width: 100%;
              height: 40px;
              position: absolute;
              top: 40%;
              left: 0;
              margin-top: -20px;
              line-height: 19px;
              text-align: center;
              z-index: 999999999999999;
            "
          >
            <p class="font-medium">Total Employee</p>
            <p class="text-4xl font-bold" v-if="!isLoading">{{ jumlah }}</p>
          </div>
          <Doughnut v-if="!isLoading" :data="data2" :options="options">
          </Doughnut>
        </div>
      </div>
    </div>

    <div
      class="block rounded-lg bg-white shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)]"
    >
      <div class="border-b-2 border-neutral-100 font-medium px-6 py-3">
        <h2>Report Complete Request</h2>
      </div>
      <div class="p-6 content-center">
        <div style="height: 300px; position: relative">
          <div
            style="
              width: 100%;
              height: 40px;
              position: absolute;
              top: 40%;
              left: 0;
              margin-top: -20px;
              line-height: 19px;
              text-align: center;
              z-index: 999999999999999;
            "
          >
            <p class="text-4xl font-bold text-blue-500">75%</p>
            <p class="font-medium text-blue-500">Completed</p>
          </div>
          <Doughnut :data="data" :options="options" />
        </div>
      </div>
    </div>
    <div>
      <div class="relative overflow-x-auto shadow-md sm:rounded-lg h-auto">
        <table
          class="w-full text-sm text-left text-gray-500 dark:text-gray-400"
        >
          <thead class="text-xs text-gray-700 uppercase bg-gray-50">
            <tr>
              <th scope="col" class="px-6 py-3" colspan="7">Who's off today</th>
            </tr>
          </thead>
          <tbody>
            <tr class="bg-white border-b">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap"
              >
                <img
                  class="w-10 h-10 rounded-full"
                  src="https://divedigital.id/wp-content/uploads/2022/04/12-1.jpg"
                  alt="Rounded avatar"
                />
              </th>
              <td class="py-4 text-gray-900">Cecep burhanudin</td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>

              <td class="px-6 py-4">
                <button
                  class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
                >
                  Absen
                </button>
              </td>
            </tr>
            <tr class="bg-white border-b">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap"
              >
                <img
                  class="w-10 h-10 rounded-full"
                  src="https://divedigital.id/wp-content/uploads/2022/04/12-1.jpg"
                  alt="Rounded avatar"
                />
              </th>
              <td class="py-4 text-gray-900">Cecep burhanudin</td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>

              <td class="px-6 py-4">
                <button
                  class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
                >
                  Absen
                </button>
              </td>
            </tr>
            <tr class="bg-white border-b">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap"
              >
                <img
                  class="w-10 h-10 rounded-full"
                  src="https://divedigital.id/wp-content/uploads/2022/04/12-1.jpg"
                  alt="Rounded avatar"
                />
              </th>
              <td class="py-4 text-gray-900">Cecep burhanudin</td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>

              <td class="px-6 py-4">
                <button
                  class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
                >
                  Absen
                </button>
              </td>
            </tr>
            <tr class="bg-white border-b">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap"
              >
                <img
                  class="w-10 h-10 rounded-full"
                  src="https://divedigital.id/wp-content/uploads/2022/04/12-1.jpg"
                  alt="Rounded avatar"
                />
              </th>
              <td class="py-4 text-gray-900">Cecep burhanudin</td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>

              <td class="px-6 py-4">
                <button
                  class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
                >
                  Absen
                </button>
              </td>
            </tr>
            <tr class="bg-white border-b">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap"
              >
                <img
                  class="w-10 h-10 rounded-full"
                  src="https://divedigital.id/wp-content/uploads/2022/04/12-1.jpg"
                  alt="Rounded avatar"
                />
              </th>
              <td class="py-4 text-gray-900">Cecep burhanudin</td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>

              <td class="px-6 py-4">
                <button
                  class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
                >
                  Absen
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div> -->
  <div class="grid grid-cols-2 gap-4">
    <div
      class="block rounded-lg bg-white shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)] h-auto"
    >
      <div
        class="border-b-2 border-neutral-100 font-medium px-6 py-3 grid grid-cols-2"
      >
        <h2>Attendance Today</h2>
        <div></div>
      </div>
      <div class="p-6 content-center">
        <div style="height: 300px; position: relative">
          <div
            style="
              width: 100%;
              height: 40px;
              position: absolute;
              top: 40%;
              left: 0;
              margin-top: -20px;
              line-height: 19px;
              text-align: center;
              z-index: 999999999999999;
            "
          >
            <p class="font-medium">Total Employee</p>
            <p class="text-4xl font-bold" v-if="!isLoading">{{ jumlah }}</p>
          </div>
          <Doughnut v-if="!isLoading" :data="data2" :options="options">
          </Doughnut>
        </div>
      </div>
    </div>

    <div
      class="block rounded-lg bg-white shadow-[0_2px_15px_-3px_rgba(0,0,0,0.07),0_10px_20px_-2px_rgba(0,0,0,0.04)]"
    >
      <div class="border-b-2 border-neutral-100 font-medium px-6 py-3">
        <h2>Report Complete Request</h2>
      </div>
      <div class="p-6 content-center">
        <div style="height: 300px; position: relative">
          <div
            style="
              width: 100%;
              height: 40px;
              position: absolute;
              top: 40%;
              left: 0;
              margin-top: -20px;
              line-height: 19px;
              text-align: center;
              z-index: 999999999999999;
            "
          >
            <p class="text-4xl font-bold text-blue-500">75%</p>
            <p class="font-medium text-blue-500">Completed</p>
          </div>
          <Doughnut :data="data" :options="options" />
        </div>
      </div>
    </div>
  </div>
  <div class="grid grid-cols-2 gap-4 py-7">
    <div v-for="(data, index) in dataProjectOffToday" :key="index">
      <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
        <table
          class="w-full text-sm text-left text-gray-500 dark:text-gray-400"
        >
          <thead class="text-xs text-gray-700 uppercase bg-gray-50">
            <tr class="bg-white border-b">
              <th class="px-6 py-3 flex justify-between items-center w-full">
                <span>Attendance {{ data.name }}</span>
                <Link :href="route('attendance.attendance-daily.index', {'branch_id': data.id })">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="16"
                    height="16"
                    fill="currentColor"
                    class="bi bi-box-arrow-up-right text-blue-500"
                    viewBox="0 0 16 16"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M8.636 3.5a.5.5 0 0 0-.5-.5H1.5A1.5 1.5 0 0 0 0 4.5v10A1.5 1.5 0 0 0 1.5 16h10a1.5 1.5 0 0 0 1.5-1.5V7.864a.5.5 0 0 0-1 0V14.5a.5.5 0 0 1-.5.5h-10a.5.5 0 0 1-.5-.5v-10a.5.5 0 0 1 .5-.5h6.636a.5.5 0 0 0 .5-.5z"
                    />
                    <path
                      fill-rule="evenodd"
                      d="M16 .5a.5.5 0 0 0-.5-.5h-5a.5.5 0 0 0 0 1h3.793L6.146 9.146a.5.5 0 1 0 .708.708L15 1.707V5.5a.5.5 0 0 0 1 0v-5z"
                    />
                  </svg>
                </Link>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="(item, indexItem) in data.attendances"
              :key="indexItem"
              class="bg-white border-b"
            >
              <td
                class="px-6 py-4 text-gray-900 w-full flex justify-between items-center"
              >
                <span>{{ item.employee_name }}</span>
                <span
                  v-if="item.attendances == 'late'"
                  class="py-[2px] px-4 bg-amber-500 text-white rounded-full"
                  style="font-size: 12px"
                >
                  Late
                </span>
                <span
                  v-else
                  class="py-[2px] px-4 bg-red-500 text-white rounded-full"
                  style="font-size: 12px"
                >
                  Absent
                </span>
              </td>
            </tr>
            <tr v-if="data.attendances.length === 0" class="bg-white border-b">
              <td
                class="px-6 py-4 text-gray-900 w-full text-center"
                colspan="2"
              >
                Data Kosong
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <!-- <div>
      <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
        <table
          class="w-full text-sm text-left text-gray-500 dark:text-gray-400"
        >
          <thead class="text-xs text-gray-700 uppercase bg-gray-50">
            <tr>
              <th scope="col" class="px-6 py-3" colspan="7">Who's off today</th>
            </tr>
          </thead>
          <tbody>
            <tr class="bg-white border-b">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap"
              >
                <img
                  class="w-10 h-10 rounded-full"
                  src="https://divedigital.id/wp-content/uploads/2022/04/12-1.jpg"
                  alt="Rounded avatar"
                />
              </th>
              <td class="py-4 text-gray-900">Cecep burhanudin</td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>

              <td class="px-6 py-4">
                <button
                  class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
                >
                  Absen
                </button>
              </td>
            </tr>
            <tr class="bg-white border-b">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap"
              >
                <img
                  class="w-10 h-10 rounded-full"
                  src="https://divedigital.id/wp-content/uploads/2022/04/12-1.jpg"
                  alt="Rounded avatar"
                />
              </th>
              <td class="py-4 text-gray-900">Cecep burhanudin</td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>

              <td class="px-6 py-4">
                <button
                  class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
                >
                  Absen
                </button>
              </td>
            </tr>
            <tr class="bg-white border-b">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap"
              >
                <img
                  class="w-10 h-10 rounded-full"
                  src="https://divedigital.id/wp-content/uploads/2022/04/12-1.jpg"
                  alt="Rounded avatar"
                />
              </th>
              <td class="py-4 text-gray-900">Cecep burhanudin</td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>

              <td class="px-6 py-4">
                <button
                  class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
                >
                  Absen
                </button>
              </td>
            </tr>
            <tr class="bg-white border-b">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap"
              >
                <img
                  class="w-10 h-10 rounded-full"
                  src="https://divedigital.id/wp-content/uploads/2022/04/12-1.jpg"
                  alt="Rounded avatar"
                />
              </th>
              <td class="py-4 text-gray-900">Cecep burhanudin</td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>

              <td class="px-6 py-4">
                <button
                  class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
                >
                  Absen
                </button>
              </td>
            </tr>
            <tr class="bg-white border-b">
              <th
                scope="row"
                class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap"
              >
                <img
                  class="w-10 h-10 rounded-full"
                  src="https://divedigital.id/wp-content/uploads/2022/04/12-1.jpg"
                  alt="Rounded avatar"
                />
              </th>
              <td class="py-4 text-gray-900">Cecep burhanudin</td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>
              <td class="px-6 py-4"></td>

              <td class="px-6 py-4">
                <button
                  class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"
                >
                  Absen
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div> -->
  </div>
</template>

<script setup>
import AppLayout from "@/layouts/apps.vue";
import { ref, onMounted, reactive } from "vue";
onMounted(() => {
  getAttendanceListData();
  getProjectOffToday();
});
</script>