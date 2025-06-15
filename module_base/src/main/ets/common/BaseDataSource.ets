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

  public reloadData(data: T[]): void {
    this.items.length = 0;
    this.items.push(...data);
    this.notifyDataReload();
  }

  public addDataWhereIndex(data: T[], startIndex: number): void {
    this.items.length = this.items.length > startIndex ? startIndex : this.items.length;
    this.items.push(...data);
    this.onDatasetChange(startIndex, data.length);
  }

  public loadMoreData(data: T[]): void {
    let t = this.totalCount()
    this.items.push(...data);
    this.onDatasetChange(t, data.length);
  }

  public onDataRefresh(data: T, index: number): void {
    this.items[index] = data
    this.notifyDataChange(index)
  }

  public clear(): void {
    this.items = []
    this.notifyDataReload()
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
      listener.onDatasetChange([{ type: DataOperationType.RELOAD }])
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{ type: DataOperationType.ADD, index: index }])
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{ type: DataOperationType.CHANGE, index: index }])
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{ type: DataOperationType.DELETE, index: index }])
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{ type: DataOperationType.MOVE, index: { from: from, to: to } }])
    })
  }

  onDatasetChange(index: number, count: number): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{ type: DataOperationType.ADD, index: index, count: count }]);
    })
  }
}

