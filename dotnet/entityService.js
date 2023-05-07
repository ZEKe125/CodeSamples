import axios from "axios";
import * as helper from "../services/serviceHelpers";

const endpoint = `${helper.API_HOST_PREFIX}/api/entities`;

const add = (payload) => {
	const config = {
		method: "POST",
		url: `${endpoint}`,
		data: payload,
		withCredentials: true,
		crossdomain: true,
		headers: { "Content-Type": "application/json" },
	};
	return axios(config);
};

const update = (payload) => {
	const config = {
		method: "PUT",
		url: `${endpoint}/${newLocation.id}`,
		data: payload,
		withCredentials: true,
		crossdomain: true,
		headers: { "Content-Type": "application/json" },
	};

	return axios(config);
};

const getById = (id) => {
	const config = {
		method: "GET",
		url: `${endpoint}/${id}`,
		withCredentials: true,
		crossdomain: true,
		headers: { "Content-Type": "application/json" },
	};
	return axios(config);
};

const getAllPaginated = (pageIndex, pageSize) => {
	const config = {
		method: "GET",
		url: `${endpoint}?pageIndex=${pageIndex}&pageSize=${pageSize}`,
		withCredentials: true,
		crossdomain: true,
		headers: { "Content-Type": "application/json" },
	};

	return axios(config);
};

const entityServices = {
	add,
	getById,
	update,
	getAllPaginated,
};

export default entityServices;
