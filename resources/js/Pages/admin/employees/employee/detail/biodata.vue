<script>
export default {
  layout: AppLayout,
};
</script>
<script setup>
import axios from "axios";
import dayjs from "dayjs";
import { notify } from "notiwind";
import { Head, Link } from "@inertiajs/inertia-vue3";
import { ref, onMounted } from "vue";
import { object, string } from "vue-types";
import AppLayout from "@/layouts/apps.vue";
import VBack from "@/components/src/icons/VBack.vue";
import VBreadcrumb from "@/components/VBreadcrumb/index.vue";
import VSidebarSetting from "@/components/VSidebarSetting/index.vue";
import VInput from "@/components/VInput/index.vue";
import VButton from "@/components/VButton/index.vue";

const props = defineProps({
  additional: object(),
  title: string(),
});

const breadcrumb = [
  {
    name: "Dashboard",
    active: false,
    to: route("dashboard.index"),
  },
  {
    name: "Employee",
    active: false,
    to: route("employment.employee.index"),
  },
  {
    name: "Employee",
    active: false,
    to: route("employment.employee.index"),
  },
  {
    name: "Biodata",
    active: true,
    to: route("employment.employee.biodataShow", {
      id: props.additional.employee.id,
    }),
  },
];

const backActive = ref(false);

const formError = ref({});
const form = ref({});

const isUpdateLoading = ref(false);

const updateData = () => {
  const fd = new FormData();

  Object.keys(form.value).forEach((key) => {
    fd.append(key, form.value[key]);
    console.log(form.value[key]);
  });

  axios
    .post(
      route("employment.employee.biodataUpdate", props.additional.employee.id),
      fd
    )
    .then((res) => {
      notify(
        {
          type: "success",
          group: "top",
          text: res.data.meta.message,
        },
        2500
      );
      console.log(res);
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
    .finally(() => (isUpdateLoading.value = false));
};

const initData = () => {
  if (props.additional.employee.employee_contract_biodata != null) {
    form.value.badge_npn =
      props.additional.employee.employee_contract_biodata.badge_npn;
    form.value.badge_abb =
      props.additional.employee.employee_contract_biodata.badge_abb;
    form.value.sektor =
      props.additional.employee.employee_contract_biodata.sektor;
    form.value.jabatan_ccpm =
      props.additional.employee.employee_contract_biodata.jabatan_ccpm;
    form.value.tempat_lahir =
      props.additional.employee.employee_contract_biodata.tempat_lahir;
    form.value.tanggal_lahir =
      props.additional.employee.employee_contract_biodata.tanggal_lahir;
    form.value.usia = props.additional.employee.employee_contract_biodata.usia;
    form.value.nik = props.additional.employee.employee_contract_biodata.nik;
    form.value.agama =
      props.additional.employee.employee_contract_biodata.agama;
    form.value.komplek =
      props.additional.employee.employee_contract_biodata.komplek;
    form.value.rt = props.additional.employee.employee_contract_biodata.rt;
    form.value.rw = props.additional.employee.employee_contract_biodata.rw;
    form.value.kelurahan =
      props.additional.employee.employee_contract_biodata.kelurahan;
    form.value.kecamatan =
      props.additional.employee.employee_contract_biodata.kecamatan;
    form.value.kabupaten =
      props.additional.employee.employee_contract_biodata.kabupaten;
    form.value.provinsi =
      props.additional.employee.employee_contract_biodata.provinsi;
    form.value.sim = props.additional.employee.employee_contract_biodata.sim;
    form.value.status_pajak =
      props.additional.employee.employee_contract_biodata.status_pajak;
    form.value.no_kk =
      props.additional.employee.employee_contract_biodata.no_kk;
    form.value.pendidikan_formal =
      props.additional.employee.employee_contract_biodata.pendidikan_formal;
    form.value.gada = props.additional.employee.employee_contract_biodata.gada;
    form.value.no_sertifikat =
      props.additional.employee.employee_contract_biodata.no_sertifikat;
    form.value.penyelenggara =
      props.additional.employee.employee_contract_biodata.penyelenggara;
    form.value.dikeluarkan_oleh =
      props.additional.employee.employee_contract_biodata.dikeluarkan_oleh;
    form.value.no_kta =
      props.additional.employee.employee_contract_biodata.no_kta;
    form.value.no_reg_kta =
      props.additional.employee.employee_contract_biodata.no_reg_kta;
    form.value.masa_berlaku =
      props.additional.employee.employee_contract_biodata.masa_berlaku;
    form.value.status_kta =
      props.additional.employee.employee_contract_biodata.status_kta;
    form.value.gol_darah =
      props.additional.employee.employee_contract_biodata.gol_darah;
  } else {
    form.value.badge_npn = "";
    form.value.badge_abb = "";
    form.value.sektor = "";
    form.value.jabatan_ccpm = "";
    form.value.tempat_lahir = "";
    form.value.tanggal_lahir = "";
    form.value.usia = "";
    form.value.nik = "";
    form.value.agama = "";
    form.value.komplek = "";
    form.value.rt = "";
    form.value.rw = "";
    form.value.kelurahan = "";
    form.value.kecamatan = "";
    form.value.kabupaten = "";
    form.value.provinsi = "";
    form.value.sim = "";
    form.value.status_pajak = "";
    form.value.no_kk = "";
    form.value.pendidikan_formal = "";
    form.value.gada = "";
    form.value.no_sertifikat = "";
    form.value.penyelenggara = "";
    form.value.dikeluarkan_oleh = "";
    form.value.no_kta = "";
    form.value.no_reg_kta = "";
    form.value.masa_berlaku = "";
    form.value.status_kta = "";
    form.value.gol_darah = "";
  }
};

onMounted(() => {
  initData();
});
</script>

<template>
  <Head :title="title"></Head>
  <VBreadcrumb :routes="breadcrumb" />
  <div class="mb-4 sm:mb-6 flex justify-start space-x-2 items-center">
    <Link :href="route('employment.employee.index')" class="cursor-pointer">
      <VBack
        width="32"
        height="32"
        :is-active="backActive"
        @mouseover="backActive = true"
        @mouseout="backActive = false"
      />
    </Link>
    <h1 class="text-2xl md:text-3xl text-slate-800 font-bold">
      Detail Employee
    </h1>
  </div>
  <!-- Content -->
  <div class="bg-white shadow-lg rounded-sm mb-8">
    <div class="flex flex-col sm:flex-row md:-mr-px">
      <VSidebarSetting :module="additional.menu" />
      <div class="grow">
        <div class="p-4">
          <div class="flex justify-between">
            <div class="font-semibold text-xl text-slate-800 mb-5">
              Additional Biodata
            </div>
          </div>
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <!-- Row 1 -->
            <VInput
              placeholder="Badge NPN"
              label="Badge NPN"
              :required="true"
              v-model="form.badge_npn"
              :errorMessage="formError.badge_npn"
              @update:modelValue="formError.badge_npn = ''"
            />
            <VInput
              placeholder="Badge ABB"
              label="Badge ABB"
              :required="true"
              v-model="form.badge_abb"
              :errorMessage="formError.badge_abb"
              @update:modelValue="formError.badge_abb = ''"
            />
            <VInput
              placeholder="Sektor"
              label="Sektor"
              :required="true"
              v-model="form.sektor"
              :errorMessage="formError.sektor"
              @update:modelValue="formError.sektor = ''"
            />
            <VInput
              placeholder="Jabatan di CCPM"
              label="Jabatan di CCPM"
              :required="true"
              v-model="form.jabatan_ccpm"
              :errorMessage="formError.jabatan_ccpm"
              @update:modelValue="formError.jabatan_ccpm = ''"
            />

            <!-- Row 2 -->
            <VInput
              placeholder="Tempat Lahir"
              label="Tempat Lahir"
              :required="true"
              v-model="form.tempat_lahir"
              :errorMessage="formError.tempat_lahir"
              @update:modelValue="formError.tempat_lahir = ''"
            />
            <VInput
              placeholder="Tanggal Lahir"
              label="Tanggal Lahir"
              :required="true"
              v-model="form.tanggal_lahir"
              :errorMessage="formError.tanggal_lahir"
              @update:modelValue="formError.tanggal_lahir = ''"
            />
            <VInput
              placeholder="Usia"
              label="Usia"
              :required="true"
              v-model="form.usia"
              :errorMessage="formError.usia"
              @update:modelValue="formError.usia = ''"
            />
            <VInput
              placeholder="NIK"
              label="NIK"
              :required="true"
              v-model="form.nik"
              :errorMessage="formError.nik"
              @update:modelValue="formError.nik = ''"
            />

            <!-- Row 3 -->
            <VInput
              placeholder="Agama"
              label="Agama"
              :required="true"
              v-model="form.agama"
              :errorMessage="formError.agama"
              @update:modelValue="formError.agama = ''"
            />
            <VInput
              placeholder="Jalan/Komplek"
              label="Jalan/Komplek"
              :required="true"
              v-model="form.komplek"
              :errorMessage="formError.komplek"
              @update:modelValue="formError.komplek = ''"
            />
            <VInput
              placeholder="RT"
              label="RT"
              :required="true"
              v-model="form.rt"
              :errorMessage="formError.rt"
              @update:modelValue="formError.rt = ''"
            />
            <VInput
              placeholder="RW"
              label="RW"
              :required="true"
              v-model="form.rw"
              :errorMessage="formError.rw"
              @update:modelValue="formError.rw = ''"
            />

            <!-- Row 4 -->
            <VInput
              placeholder="Kelurahan/Desa"
              label="Kelurahan/Desa"
              :required="true"
              v-model="form.kelurahan"
              :errorMessage="formError.kelurahan"
              @update:modelValue="formError.kelurahan = ''"
            />
            <VInput
              placeholder="Kecamatan"
              label="Kecamatan"
              :required="true"
              v-model="form.kecamatan"
              :errorMessage="formError.kecamatan"
              @update:modelValue="formError.kecamatan = ''"
            />
            <VInput
              placeholder="Kabupaten/Kota"
              label="Kabupaten/Kota"
              :required="true"
              v-model="form.kabupaten"
              :errorMessage="formError.kabupaten"
              @update:modelValue="formError.kabupaten = ''"
            />
            <VInput
              placeholder="Provinsi"
              label="Provinsi"
              :required="true"
              v-model="form.provinsi"
              :errorMessage="formError.provinsi"
              @update:modelValue="formError.provinsi = ''"
            />

            <!-- Row 5 -->
            <VInput
              placeholder="SIM"
              label="SIM"
              :required="true"
              v-model="form.sim"
              :errorMessage="formError.sim"
              @update:modelValue="formError.sim = ''"
            />
            <VInput
              placeholder="Status Pajak"
              label="Status Pajak"
              :required="true"
              v-model="form.status_pajak"
              :errorMessage="formError.status_pajak"
              @update:modelValue="formError.status_pajak = ''"
            />
            <VInput
              placeholder="No. KK"
              label="No. KK"
              :required="true"
              v-model="form.no_kk"
              :errorMessage="formError.no_kk"
              @update:modelValue="formError.no_kk = ''"
            />
            <VInput
              placeholder="Pendidikan Formal"
              label="Pendidikan Formal"
              :required="true"
              v-model="form.pendidikan_formal"
              :errorMessage="formError.pendidikan_formal"
              @update:modelValue="formError.pendidikan_formal = ''"
            />

            <!-- Row 6 -->
            <VInput
              placeholder="Gada"
              label="Gada"
              :required="true"
              v-model="form.gada"
              :errorMessage="formError.gada"
              @update:modelValue="formError.gada = ''"
            />
            <VInput
              placeholder="No. Sertifikat/Ijazah"
              label="No. Sertifikat/Ijazah"
              :required="true"
              v-model="form.no_sertifikat"
              :errorMessage="formError.no_sertifikat"
              @update:modelValue="formError.no_sertifikat = ''"
            />
            <VInput
              placeholder="Penyelenggara"
              label="Penyelenggara"
              :required="true"
              v-model="form.penyelenggara"
              :errorMessage="formError.penyelenggara"
              @update:modelValue="formError.penyelenggara = ''"
            />
            <VInput
              placeholder="Dikeluarkan Oleh"
              label="Dikeluarkan Oleh"
              :required="true"
              v-model="form.dikeluarkan_oleh"
              :errorMessage="formError.dikeluarkan_oleh"
              @update:modelValue="formError.dikeluarkan_oleh = ''"
            />

            <!-- Row 7 -->
            <VInput
              placeholder="No. KTA"
              label="No. KTA"
              :required="true"
              v-model="form.no_kta"
              :errorMessage="formError.no_kta"
              @update:modelValue="formError.no_kta = ''"
            />
            <VInput
              placeholder="No. Reg KTA"
              label="No. Reg KTA"
              :required="true"
              v-model="form.no_reg_kta"
              :errorMessage="formError.no_reg_kta"
              @update:modelValue="formError.no_reg_kta = ''"
            />
            <VInput
              placeholder="Masa Berlaku"
              label="Masa Berlaku"
              :required="true"
              v-model="form.masa_berlaku"
              :errorMessage="formError.masa_berlaku"
              @update:modelValue="formError.masa_berlaku = ''"
            />
            <VInput
              placeholder="Status KTA"
              label="Status KTA"
              :required="true"
              v-model="form.status_kta"
              :errorMessage="formError.status_kta"
              @update:modelValue="formError.status_kta = ''"
            />

            <!-- Row 8 -->
            <VInput
              placeholder="Gol. Darah"
              label="Gol. Darah"
              class="col-span-1 sm:col-span-2 lg:col-span-4"
              :required="true"
              v-model="form.gol_darah"
              :errorMessage="formError.gol_darah"
              @update:modelValue="formError.gol_darah = ''"
            />

            <div
              class="col-span-1 sm:col-span-2 lg:col-span-4 flex justify-end"
            >
              <VButton
                :is-loading="isUpdateLoading"
                @click="updateData()"
                label="Update"
                type="primary"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
