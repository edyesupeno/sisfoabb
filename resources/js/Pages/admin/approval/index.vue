<script>
export default {
  layout: AppLayout,
};
</script>
<script setup>
import axios from "axios";
import { notify } from "notiwind";
import { object, string } from "vue-types";
import { Head } from "@inertiajs/inertia-vue3";
import { ref, onMounted } from "vue";
import AppLayout from "@/layouts/apps.vue";
import debounce from "@/composables/debounce";
import VDropdownEditMenu from "@/components/VDropdownEditMenu/index.vue";
import VDataTable from "@/components/VDataTable/index.vue";
import VPagination from "@/components/VPagination/index.vue";
import VBreadcrumb from "@/components/VBreadcrumb/index.vue";
import VLoading from "@/components/VLoading/index.vue";
import VEmpty from "@/components/src/icons/VEmpty.vue";
import VBadge from "@/components/VBadge/index.vue";
import VDetail from "@/components/src/icons/VDetail.vue";
import VModalForm from "./ModalForm.vue";
import VButton from "@/components/VButton/index.vue";
import VModalTemplate from "./ModalTemplate.vue";

const query = ref([]);
const query2 = ref([]);
const breadcrumb = [
  {
    name: "Dashboard",
    active: false,
    to: route("dashboard.index"),
  },
  {
    name: "Approval",
    active: true,
    to: route("approval.index"),
  },
];
const pagination = ref({
  count: "",
  current_page: 1,
  per_page: "",
  total: 0,
  total_pages: 1,
});
const itemSelected = ref({});
const openModalForm = ref(false);
const openModalTemplate = ref(false);
const heads = ["Type", "Status", "Created By", "Created At", "Branch", ""];
const isLoading = ref(true);
const isapproval = ref(true);
const isImportExcelLoading = ref(false);

const formImportExcel = ref();
const fileImportExcel = ref(null);

const props = defineProps({
  title: string(),
  additional: object(),
});

const getData = debounce(async (page) => {
  axios
    .get(route("approval.getdata"), {
      params: {
        page: page,
      },
    })
    .then((res) => {
      query.value = res.data.data;
      pagination.value = res.data.meta.pagination;
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

const getData2 = debounce(async (page) => {
  axios
    .get(route("approval.getlembur"), {
      params: {
        page: page,
        // employee_id: '1',
        // filter_date: ['2023-06-01T17:00:00.000Z', '2023-08-02T17:00:00.000Z']
      },
    })
    .then((res) => {
      query2.value = res.data.data;
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

const nextPaginate = () => {
  pagination.value.current_page += 1;
  isLoading.value = true;
  getData(pagination.value.current_page);
};

const previousPaginate = () => {
  pagination.value.current_page -= 1;
  isLoading.value = true;
  getData(pagination.value.current_page);
};

//handle flip flop is approval
const handleIsApproval = (i) => {
  isapproval.value = i;
};

const handleDetailEmployee = (data) => {
  itemSelected.value = data;
  openModalForm.value = true;
};

const successSubmit = () => {
  isLoading.value = true;
  getData(pagination.value.current_page);
};

const closeModalForm = () => {
  itemSelected.value = ref({});
  openModalForm.value = false;
  getData2();
};

const getStatusValue = (value) => {
  if (value === "awaiting") {
    return "warning";
  } else if (value === "approved") {
    return "success";
  } else if (value === "rejected") {
    return "danger";
  } else {
    return "primary";
  }
};

const handleAddModalTemplate = () => {
  openModalTemplate.value = true;
};

const successDownload = () => {
  openModalTemplate.value = false;
};

const closeModalTemplate = () => {
  openModalTemplate.value = false;
};

const handleImportExcel = () => {
  formImportExcel.value.click();
};

const handleChangeImportExcel = (e) => {
  fileImportExcel.value = e.target.files[0];
  isImportExcelLoading.value = true;

  const formData = new FormData();
  formData.append("import_excel", e.target.files[0]);

  axios
    .post(route("approval.lemburimport"), formData)
    .then((res) => {
      if (res.data.meta.success == false) {
        notify(
          {
            type: "error",
            group: "top",
            text: res.data.meta.message,
          },
          2500
        );
      } else {
        notify(
          {
            type: "success",
            group: "top",
            text: res.data.meta.message,
          },
          2500
        );
        // window.location.reload();
        isLoading.value = true;
        getData();
      }
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
    .finally(() => (isImportExcelLoading.value = false));
};

onMounted(() => {
  getData(1);
  getData2(1);
});
</script>

<template>
  <Head :title="props.title" />
  <VBreadcrumb :routes="breadcrumb" />
  <div class="mb-4 sm:mb-6 flex justify-between items-center">
    <h1 class="text-2xl md:text-3xl text-slate-800 font-bold">Approval</h1>
  </div>

  <div
    class="bg-white shadow-lg rounded-sm border border-slate-200"
    :class="isLoading && 'min-h-[40vh] sm:min-h-[50vh]'"
  >
    <ul
      class="flex flex-wrap text-sm font-medium text-center text-gray-500 dark:text-gray-400 px-5 py-5"
    >
      <li class="mr-2">
        <a
          href="#"
          v-if="!isapproval"
          v-on:click="handleIsApproval(true)"
          class="inline-block px-4 py-3 rounded-lg hover:text-gray-900 hover:bg-gray-100 dark:hover:bg-gray-800 dark:hover:text-white"
          aria-current="page"
          >Approval</a
        >
        <a
          href="#"
          v-if="isapproval"
          v-on:click="handleIsApproval(true)"
          class="inline-block px-4 py-3 text-white bg-blue-600 rounded-lg active"
          aria-current="page"
          >Approval</a
        >
      </li>
      <li class="mr-2">
        <a
          href="#"
          v-if="isapproval"
          v-on:click="handleIsApproval(false)"
          class="inline-block px-4 py-3 rounded-lg hover:text-gray-900 hover:bg-gray-100 dark:hover:bg-gray-800 dark:hover:text-white"
          >Submitting overtime</a
        >
        <a
          href="#"
          v-if="!isapproval"
          v-on:click="handleIsApproval(false)"
          class="inline-block px-4 py-3 text-white bg-blue-600 rounded-lg active"
          >Submitting overtime</a
        >
      </li>
    </ul>
    <div v-if="isapproval">
      <header class="block justify-between items-center sm:flex py-6 px-4">
        <h2 class="font-semibold text-slate-800">
          All Approvals
          <span class="text-slate-400 !font-medium ml">{{
            pagination.total
          }}</span>
        </h2>
      </header>

      <VDataTable :heads="heads" :isLoading="isLoading">
        <tr v-if="isLoading">
          <td class="h-[100%] overflow-hidden my-2" :colspan="heads.length">
            <VLoading />
          </td>
        </tr>
        <tr v-else-if="query.length === 0 && !isLoading">
          <td class="overflow-hidden my-2" :colspan="heads.length">
            <div class="flex items-center flex-col w-full my-32">
              <VEmpty />
              <div class="mt-9 text-slate-500 text-xl md:text-xl font-medium">
                Result not found.
              </div>
            </div>
          </td>
        </tr>
        <tr v-for="(data, index) in query2" :key="index" v-else>
          <td class="px-4 whitespace-nowrap h-16 capitalize">
            {{ data.type.replace(/_/g, " ") }}
          </td>
          <td class="px-4 whitespace-nowrap h-16 capitalize">
            <VBadge
              :text="data.status"
              :color="getStatusValue(data.status)"
              size="sm"
            />
          </td>
          <td class="px-4 whitespace-nowrap h-16">{{ data.created_by }}</td>
          <td class="px-4 whitespace-nowrap h-16">{{ data.created_at }}</td>
          <td class="px-4 whitespace-nowrap h-16">{{ data.branch }}</td>
          <td class="px-4 whitespace-nowrap h-16 text-right">
            <VDropdownEditMenu
              class="relative inline-flex r-0"
              :align="'right'"
              :last="index === query.length - 1 ? true : false"
            >
              <li
                class="cursor-pointer hover:bg-slate-100"
                @click="handleDetailEmployee(data)"
              >
                <div class="flex items-center space-x-2 p-3">
                  <span>
                    <VDetail color="primary" />
                  </span>
                  <span>Detail</span>
                </div>
              </li>
            </VDropdownEditMenu>
          </td>
        </tr>
      </VDataTable>
      <div class="px-4 py-6">
        <VPagination
          :pagination="pagination"
          @next="nextPaginate"
          @previous="previousPaginate"
        />
      </div>
    </div>
    <div v-if="!isapproval">
      <header class="block justify-between items-center sm:flex py-6 px-4">
        <h2 class="font-semibold text-slate-800">
          Submitting Overtime
          <span class="text-slate-400 !font-medium ml">{{
            pagination.total
          }}</span>
        </h2>
        <div class="flex">
          <!-- Import Excel -->
          <input
            type="file"
            ref="formImportExcel"
            accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel"
            @change="handleChangeImportExcel"
            hidden
          />
          <VButton
            label="Import"
            type="success"
            @click="handleImportExcel"
            class="mt-auto"
            :isLoading="isImportExcelLoading"
          />
          <VButton
            label="Template"
            type="success"
            @click="handleAddModalTemplate"
            class="mt-auto"
          />
        </div>
      </header>

      <VDataTable :heads="heads" :isLoading="isLoading">
        <tr v-if="isLoading">
          <td class="h-[100%] overflow-hidden my-2" :colspan="heads.length">
            <VLoading />
          </td>
        </tr>
        <tr v-else-if="query2.length === 0 && !isLoading">
          <td class="overflow-hidden my-2" :colspan="heads.length">
            <div class="flex items-center flex-col w-full my-32">
              <VEmpty />
              <div class="mt-9 text-slate-500 text-xl md:text-xl font-medium">
                Result not found.
              </div>
            </div>
          </td>
        </tr>
        <tr v-for="(data, index) in query2" :key="index" v-else>
          <td class="px-4 whitespace-nowrap h-16 capitalize">
            Approval Lembur
          </td>
          <td class="px-4 whitespace-nowrap h-16 capitalize">
            <VBadge
              :text="data.status"
              :color="getStatusValue(data.status)"
              size="sm"
            />
          </td>
          <td class="px-4 whitespace-nowrap h-16">{{ data.created_by }}</td>
          <td class="px-4 whitespace-nowrap h-16">{{ data.created_at }}</td>
          <td class="px-4 whitespace-nowrap h-16">{{ data.branch }}</td>
          <td class="px-4 whitespace-nowrap h-16 text-right">
            <VDropdownEditMenu
              class="relative inline-flex r-0"
              :align="'right'"
              :last="index === query.length - 1 ? true : false"
            >
              <li
                class="cursor-pointer hover:bg-slate-100"
                @click="handleDetailEmployee(data)"
              >
                <div class="flex items-center space-x-2 p-3">
                  <span>
                    <VDetail color="primary" />
                  </span>
                  <span>Detail</span>
                </div>
              </li>
            </VDropdownEditMenu>
          </td>
        </tr>
      </VDataTable>
      <div class="px-4 py-6">
        <VPagination
          :pagination="pagination"
          @next="nextPaginate"
          @previous="previousPaginate"
        />
      </div>
    </div>
  </div>

  <VModalForm
    :data="itemSelected"
    :open-dialog="openModalForm"
    @close="closeModalForm"
    @successSubmit="successSubmit"
    :additional="additional"
  />
  <VModalTemplate
    :open-dialog="openModalTemplate"
    @close="closeModalTemplate"
    @successSubmit="successDownload"
    :additional="additional"
  />
</template>
