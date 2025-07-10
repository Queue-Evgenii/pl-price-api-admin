import { type AxiosInstance } from 'axios';

export class Api {
  protected apiClient: AxiosInstance;
  protected endpoint: string;
  constructor(apiClient: AxiosInstance, endpoint: string) {
    this.apiClient = apiClient;
    this.endpoint = endpoint;
  }

  protected getRequest = async <T>(node: string, params: unknown): Promise<T> => {
    return this.apiClient.get(this.endpoint + node, { params }).then((res) => res.data);
  };

  protected postRequest = async <T, S>(node: string, payload: S): Promise<T> => {
    return this.apiClient.post(this.endpoint + node, payload).then((res) => res.data);
  };

  protected patchRequest = async <T, S>(node: string, payload: S): Promise<T> => {
    return this.apiClient.patch(this.endpoint + node, payload).then((res) => res.data);
  };

  protected deleteRequest = async <T>(node: string): Promise<T> => {
    return this.apiClient.delete(this.endpoint + node).then((res) => res.data);
  };
}
