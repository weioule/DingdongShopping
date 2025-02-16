/**
 * @author weioule
 * @date 2025-02-01
 * BaseDataSource
 */
export class BaseDataSource<T> implements IDataSource {
  private items: T[] = [];
  private listeners: DataChangeListener[] = [];

  totalCount(): number {
    return this.items.length;
  }

  getDataArray(): T[] {
    return this.items;
  }

  getData(index: number): T {
    return this.items[index];
  }

  public onDataRefresh(data: T, index: number): void {
    this.items[index] = data
    this.notifyDataChange(index)
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const index = this.listeners.indexOf(listener)
    if (index >= 0) {
      this.listeners.splice(index, 1)
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }

  public reloadData(data: T[]): void {
    this.items.length = 0;
    this.items.push(...data);
    this.notifyDataReload();
  }

  public reloadDataWhereIndex(data: T[], startIndex: number): void {
    this.items.length = this.items.length > startIndex ? startIndex : this.items.length;
    this.items.push(...data);
    this.notifyDataReload();
  }

  public loadMoreData(data: T[]): void {
    this.items.push(...data);
    this.notifyDataReload();
  }

  public clear(): void {
    this.items = []
  }
}

